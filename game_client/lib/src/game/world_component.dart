import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:game_client/src/game_model/model.dart';
import 'package:game_client/src/game_view/world_view_service.dart';
import 'package:game_client/src/services/gateway_service.dart';
import 'package:game_client/src/services/settings_service.dart';
import 'package:game_client/src/services/app_service.dart';
import 'package:game_client/src/services/game_service.dart';
import 'package:shared/model/model.dart' as shared;
import 'package:stagexl/stagexl.dart' as stage_lib;

@Component(
    selector: 'world',
    template: r'''
        <canvas id="worldMap" #world [ngStyle]="{'width': widthString, 'height': heightString}"></canvas>
        <canvas id="mapObjects" #objects [ngStyle]="{'width': widthString, 'height': heightString}"></canvas>
        <div id="eventOverlay" [ngStyle]="{'width': widthString, 'height': heightString}"
        (mousedown)="onMouseDown($event)"
        (mouseup)="onMouseUp($event)"
        (mousemove)="onMouseMove($event)"
        (mouseout)="onMouseOut($event)"
        (mousewheel)="onMouseWheel($event)"

        ></div>
      ''',
    styles: [
      """
      :host{
        display: block;
        position:absolute;
        top: 0;
      }
    """
    ],
    directives: [coreDirectives],
    changeDetection: ChangeDetectionStrategy.OnPush)
class WorldComponent implements OnDestroy {
  String get widthString => "${window.innerWidth}px";

  String get heightString => "${window.innerHeight}px";
  bool destroyed = false;
  stage_lib.Stage worldStage;
  stage_lib.Stage unitStage;
  AppService appService;
  GameService gameService;
  final WorldViewService view;
  CanvasElement worldElement;
  CanvasElement mapObjectsElement;
  StreamSubscription onResizeSubscription;
  ChangeDetectorRef changeDetector;
  final SettingsService settings;
  final GatewayService gateway;
  UnitManager unitManager;

  bool _moving = false;
  Unit _draggedUnit;
  Point _start;
  int _startOffsetTop;
  int _startOffsetLeft;
  ClientField _lastActiveField;
  ClientWorld world;

  WorldComponent(this.changeDetector, this.settings, this.appService, this.gateway, this.gameService, this.view) {
    onResizeSubscription = window.onResize.listen(detectChanges);
    gameService.onWorldLoaded.listen(modelLoaded);
    gateway.handlers[shared.OnClientAction.intentionUpdate] = handleIntentionUpdate;
  }

  @ViewChild("world")
  set worldElementRef(Element element) {
    worldElement = element as CanvasElement;
  }

  @ViewChild("objects")
  set objectsElementRef(Element element) {
    mapObjectsElement = element as CanvasElement;
  }

  void handleIntentionUpdate(shared.ToClientMessage message){
    String activeFieldId = message.getIntentionUpdate.activeFieldId;
    String playerId = message.getIntentionUpdate.playerId;
    Player player = appService.players[playerId];
    int color = player.color;
    unitManager.addIntention(world.fields[activeFieldId], color);
  }

  void detectChanges([dynamic _]) {
    if (destroyed || view == null) return;
    view.repaint();
    changeDetector.markForCheck();
    changeDetector.detectChanges();
  }

  void modelLoaded(ClientWorld input) {
    world = input;
    worldStage = stage_lib.Stage(worldElement,
        width: window.innerWidth,
        height: window.innerHeight,
        options: stage_lib.StageOptions()
          ..antialias = true
          ..backgroundColor = stage_lib.Color.Transparent);
    worldStage.scaleMode = stage_lib.StageScaleMode.NO_SCALE;
    worldStage.align = stage_lib.StageAlign.TOP_LEFT;
    view.construct(worldStage, world);

    unitStage = stage_lib.Stage(mapObjectsElement,
        width: window.innerWidth,
        height: window.innerHeight,
        options: stage_lib.StageOptions()
          ..antialias = true
          ..backgroundColor = 0
          ..transparent = true);
    unitStage.scaleMode = stage_lib.StageScaleMode.NO_SCALE;
    unitStage.align = stage_lib.StageAlign.TOP_LEFT;
    unitManager = UnitManager(unitStage, view, settings);
    var renderLoop = stage_lib.RenderLoop();
    renderLoop.addStage(unitStage);
    detectChanges();
  }

  void onMouseDown(MouseEvent event) {
    event.preventDefault();
    event.stopPropagation();
    ClientField field = world.getFieldByMouseOffset(event.page.x, event.page.y);
    Unit unit = field.getFirstPlayableUnitOnField();
    if (unit != null) {
      _draggedUnit = unit;
    } else {
      _moving = true;
      _start = event.page;
      _startOffsetTop = world.userTopOffset;
      _startOffsetLeft = world.userLeftOffset;
    }
  }

  void onMouseUp(MouseEvent event) {
    event.preventDefault();
    event.stopPropagation();
    if (_draggedUnit != null) {
      ClientField field = world.getFieldByMouseOffset(event.page.x, event.page.y);
      List<String> path = _draggedUnit.field.getShortestPath(field);
      shared.Track track = shared.Track.fromIds(path, null);
      shared.Ability ability = _draggedUnit.getAbility(
          track, event.shiftKey, event.altKey, event.ctrlKey);
      if (ability != null) {
//        gateway.sendCommand(_draggedUnit, track.path, ability);
      } else {
        appService.alertError(
            "No ability for ${_draggedUnit.name} | ${_draggedUnit.whyNoAbility(track).join(" | ")}");
      }
//      _draggedUnit.unit.move(track);
//      _draggedUnit.field = field;
    }
    _moving = false;
    _draggedUnit = null;
  }

  void onMouseMove(MouseEvent event) {
    event.preventDefault();
    event.stopPropagation();
    if (!_moving) {
      ClientField field = world.getFieldByMouseOffset(event.page.x, event.page.y);
      if(field != _lastActiveField){
        gateway.setActiveField(field);
        unitManager.setActiveField(field);
        _lastActiveField = field;
      }
      return;
    }
    if (_draggedUnit != null) {
      return;
    }
    int deltaX = (event.page.x - _start.x).toInt();
    int deltaY = (event.page.y - _start.y).toInt();
    world.userLeftOffset = _startOffsetLeft - deltaX;
    world.userTopOffset = _startOffsetTop - deltaY;
    // TODO: stack on anim frame
    world.recalculate();
    view.repaint();
  }

  void onMouseWheel(WheelEvent event) {
    event.preventDefault();
    event.stopPropagation();
    double zoomMultiply = event.deltaY < 0 ? 1.1 : 0.9;
    world.zoom *= zoomMultiply;

    if (world.zoom < 0.3) {
      world.zoom = 0.3;
    } else {
      int topOfMap = (event.page.y + world.userTopOffset).toInt();
      int leftOfMap = (event.page.x + world.userLeftOffset).toInt();
      world.userLeftOffset += (leftOfMap * zoomMultiply - leftOfMap).toInt();
      world.userTopOffset += (topOfMap * zoomMultiply - topOfMap).toInt();
    }
    world.recalculate();
    view.repaint();
  }

  void onMouseOut(MouseEvent event) {
    event.preventDefault();
    event.stopPropagation();
    _moving = false;
    _draggedUnit = null;
  }

  @override
  void ngOnDestroy() {
    destroyed = true;
    onResizeSubscription.cancel();
  }
}
