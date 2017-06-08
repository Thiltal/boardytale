part of world_view;

/// lifecycle wrapper around stagexl bitmap fixed on map field
/// if active added to stage or waiting for image data
/// scaled according to map
abstract class Paintable {
  SizedField _field;
  stage_lib.Bitmap _bitmap;
  String _state = "default";
  WorldView view;
  stage_lib.Stage stage;
  int height;
  int width;
  int leftOffset = 0;
  int topOffset = 0;

  Paintable(this.view, this._field, this.stage) {
    view.model.onDimensionsChanged.add(_transformBitmap);
  }

  stage_lib.Bitmap get bitmap => _bitmap;

  set bitmap(stage_lib.Bitmap value) {
    if(stage.contains(bitmap)){
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

  SizedField get field => _field;

  set field(SizedField value) {
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
    } else if(stage.contains(bitmap)){
      stage.removeChild(bitmap);
    }
  }

  Future<stage_lib.Bitmap> createBitmap();

  // scale bitmap according to map
  void _transformBitmap() {
    if(bitmap == null || field == null)return;
    bitmap.x = _field.offset.x + (leftOffset * view.model.zoom);
    bitmap.y = _field.offset.y + (topOffset * view.model.zoom);
    bitmap.width = width * view.model.zoom;
    bitmap.height = height * view.model.zoom;
  }

  void destroy();
}