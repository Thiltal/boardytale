import 'package:angular/angular.dart';
import 'package:game_client/src/create_game/create_game_component.dart';
import 'package:game_client/src/services/state_service.dart';
import 'package:game_client/src/user_bar/user_bar.component.dart';
import 'package:shared/model/model.dart';

@Component(
    selector: 'my-app',
    template: '''
  <div class="main-wrapper">
    <user-bar class="navbar navbar-expand-lg navbar-light bg-light"></user-bar>
  </div>
  <create-game
    *ngIf="showCreateGame"
  ></create-game>
  {{showCreateGame}}
  ''',
    directives: [UserBarComponent, CreateGameComponent, NgIf],
    changeDetection: ChangeDetectionStrategy.OnPush)
class AppComponent {
  StateService state;
  final ChangeDetectorRef changeDetector;

  bool get showCreateGame =>
      state.navigationState.value.name ==
      GameNavigationState.createGame;

  AppComponent(this.state, this.changeDetector){
    state.navigationState.listen((_)=>changeDetector.markForCheck());
  }
}
