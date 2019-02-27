part of model;

@Typescript()
abstract class UnitTypeCommons {
  String name;
  Races race;
  List<UnitTypeTag> tags;
  int health;
  int armor;
  int speed;
  int range;
  int actions;
  String attack;
  int cost;
  Map<Lang, String> langName;
  int unitTypeDataVersion = 0;
  int unitTypeVersion = 0;
}

@Typescript()
@JsonSerializable()
class UnitTypeCreateEnvelope extends UnitTypeCommons {
  AbilitiesEnvelope abilities;
  String authorEmail;
  String created;
  String imageName;
  String iconName;
  String bigImageName;

  static UnitTypeCreateEnvelope fromJson(Map data) {
    return _$UnitTypeCreateEnvelopeFromJson(data);
  }

  Map<String, dynamic> toJson() {
    return _$UnitTypeCreateEnvelopeToJson(this);
  }
}

@Typescript()
@JsonSerializable()
class UnitTypeCompiled extends UnitTypeCommons {
  AbilitiesEnvelope abilities;
  String authorEmail;
  Image image;
  Image icon;
  Image bigImage;

  static UnitTypeCompiled fromJson(Map data) {
    return _$UnitTypeCompiledFromJson(data);
  }

  Map<String, dynamic> toJson() {
    return _$UnitTypeCompiledToJson(this);
  }
}

class UnitType extends UnitTypeCommons {
  Image bigImage;
  Image image;
  Image icon;
  AbilitiesEnvelope abilities;

  void fromCompiledUnitType(UnitTypeCompiled data) {
    abilities = data.abilities;
    bigImage = data.bigImage;
    image = data.image;
    icon = data.icon;
    race = data.race;
    name = data.name;
    health = data.health;
    armor = data.armor;
    speed = data.speed;
    range = data.range;
    actions = data.actions;
    attack = data.attack;
    cost = data.cost;
  }
}

@Typescript()
enum UnitTypeTag {
  @JsonValue('undead')
  undead,
  @JsonValue('ethernal')
  ethernal,
  @JsonValue('mechanic')
  mechanic,
}
