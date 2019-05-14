part of world_view;

/// lifecycle wrapper around stagexl bitmap fixed on map field
/// if active added to stage or waiting for image data
/// scaled according to map
abstract class Paintable {
  ClientField _field;
  stage_lib.Bitmap _bitmap;
  String _state = "default";
  WorldViewService view;
  stage_lib.Stage stage;
  int height;
  int width;
  int leftOffset = 0;
  int topOffset = 0;
  bool _destroyed = false;
  bool _createBitmapOrdered = false;
  StreamSubscription _onDimensionChangedSubscription;

  GameService get gameService => view.gameService;

  SettingsService get settings => view.settings;

  Paintable(this.view, this._field, this.stage) {
    width = settings.defaultFieldWidth;
    height = settings.defaultFieldHeight;
    _onDimensionChangedSubscription = view.gameService.onDimensionsChanged.listen(_transformBitmap);
  }

  stage_lib.Bitmap get bitmap => _bitmap;

  set bitmap(stage_lib.Bitmap value) {
    if (stage.contains(bitmap)) {
      stage.removeChild(bitmap);
    }
    _bitmap = value;
    _resolveState();
  }

  String get state => _state;

  set state(String value) {
    _state = value;
    _resolveState();
  }

  ClientField get field => _field;

  set field(ClientField value) {
    _field = value;
    _resolveState();
  }

  void _resolveState() {
    if (field != null) {
      if (bitmap != null) {
        if (!stage.contains(bitmap)) {
          stage.addChild(bitmap);
        }
        _transformBitmap();
      }
    } else if (stage.contains(bitmap)) {
      stage.removeChild(bitmap);
    }
  }

  void createBitmap([_]) {
    if (_createBitmapOrdered) return;
    if (_destroyed) {
      print("creating bitmap of destroyed element");
      return;
    }
    _createBitmapOrdered = true;
    Future.delayed(const Duration(milliseconds: 30)).then((_) {
      if (_destroyed) {
        return;
      }
      _createBitmapOrdered = false;
      createBitmapInner();
      _transformBitmap();
    });
  }

  Future createBitmapInner();

  // scale bitmap according to map
  void _transformBitmap([_]) {
    if (bitmap == null || field == null) return;
    double zoom = view.gameService.worldParams.zoom;
    bitmap.x = _field.offset.x + (leftOffset * zoom);
    bitmap.y = _field.offset.y + (topOffset * zoom);
    bitmap.width = width * zoom;
    bitmap.height = height * zoom;
  }

  void destroy() {
    if (_destroyed) throw "double destroy";
    _onDimensionChangedSubscription.cancel();
    if (stage.contains(bitmap)) {
      stage.removeChild(bitmap);
    } else {
      print("bitmap on field ${field.id} is not in stage");
    }
    _destroyed = true;
    field = null;
    bitmap = null;
  }
}
