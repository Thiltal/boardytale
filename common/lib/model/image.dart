part of model;

class Image {
  int id;
  String data;
  int width;
  int height;
  int top = 0; // option to possible make smaller images
  int left = 0;
  String name;
  String type;
  String authorId;
  String parentId;
  bool published = false;
  Image parent;
  User author;
  double rating = 100.0;
  DateTime created;
  List<String> tags;
  Set<Image> versions = new Set<Image>();

  void fromMap(Map data) {
    dynamic __id = data["id"];
    if (__id != null){
        id = __id;
    }
    assert(id != null);
    authorId = data["authorId"];
    parentId = data["parentId"];
    rating = data["rating"];
    created = new DateTime.fromMillisecondsSinceEpoch(data["created"]);
    if (data["data"] is String) {
      data = data["data"];
    }
    if (data["width"] is int) {
      width = data["width"];
    }
    if (data["height"] is int) {
      height = data["height"];
    }
    if (data["name"] is String) {
      name = data["name"];
    }
    if (data["type"] is String) {
      type = data["type"];
    }
    if (data["published"] is bool) {
      published = data["published"];
    }
    if (data["tags"] is List<String>) {
      tags = data["tags"];
    }
  }

  Map toMap() {
    Map out = {};
    out["id"] = id;
    out["data"] = data;
    out["width"] = width;
    out["height"] = height;
    out["top"] = top;
    out["left"] = left;
    out["name"] = name;
    return out;
  }
}

class Images {
  static Map<String, Image> images = {};

  void fromMap(Map data) {
    data.forEach((String id, Map image) {
      images[id] = new Image()
        ..fromMap(image);
    });
    images.forEach((String id, Image image) {
      if (image.authorId != null) {
        image.author = Users.users[image.authorId];
      }
      if (image.parentId != null) {
        image.parent = images[image.parentId];
        image.parent.versions.add(image);
      }
    });
  }
}