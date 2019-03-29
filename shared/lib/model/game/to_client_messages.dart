part of model;

@JsonSerializable()
class ToClientMessage {
  OnClientAction message;
  String content;

  ToClientMessage();

  static ToClientMessage fromJson(Map<String, dynamic> json) => _$ToClientMessageFromJson(json);

  Map<String, dynamic> toJson() {
    return _$ToClientMessageToJson(this);
  }

  // ---

  RefreshLobbyList get refreshLobbyListMessage => RefreshLobbyList.fromJson(json.decode(content));

  factory ToClientMessage.fromLobbyList(List<OpenedLobby> lobbyList) {
    return ToClientMessage()
      ..message = OnClientAction.refreshLobbyList
      ..content = json.encode((RefreshLobbyList()..lobbies = lobbyList).toJson());
  }

  // ---

  SetNavigationState get navigationStateMessage => SetNavigationState.fromJson(json.decode(content));

  factory ToClientMessage.fromSetNavigationState(GameNavigationState newState, {bool destroyCurrentTale: false}) {
    return ToClientMessage()
      ..message = OnClientAction.setNavigationState
      ..content = json.encode((SetNavigationState()
            ..newState = newState
            ..destroyCurrentTale = destroyCurrentTale)
          .toJson());
  }

  // ---

  GetGamesToCreate get getGamesToCreateMessage => GetGamesToCreate.fromJson(json.decode(content));

  factory ToClientMessage.fromGamesToCreateMessage(List<LobbyTale> lobbyList) {
    return ToClientMessage()
      ..message = OnClientAction.getGamesToCreate
      ..content = json.encode((GetGamesToCreate()..games = lobbyList).toJson());
  }

  // ---

  SetCurrentUser get getCurrentUser => SetCurrentUser.fromJson(json.decode(content));

  factory ToClientMessage.fromCurrentUser(User user) {
    return ToClientMessage()
      ..message = OnClientAction.setCurrentUser
      ..content = json.encode((SetCurrentUser()..user = user).toJson());
  }

  // ---

  OpenedLobbyData get getOpenedLobbyData => OpenedLobbyData.fromJson(json.decode(content));

  factory ToClientMessage.fromOpenedLobby(OpenedLobby lobby) {
    return ToClientMessage()
      ..message = OnClientAction.openedLobbyData
      ..content = json.encode((OpenedLobbyData()..lobby = lobby).toJson());
  }

  // ---

  TaleData get getTaleDataMessage => TaleData.fromJson(json.decode(content));

  factory ToClientMessage.fromTaleData(InitialTaleData data) {
    return ToClientMessage()
      ..message = OnClientAction.taleData
      ..content = json.encode((TaleData()..data = data).toJson());
  }

  // ---

  UnitCreateOrUpdate get getUnitCreateOrUpdate => UnitCreateOrUpdate.fromJson(json.decode(content));

  factory ToClientMessage.fromUnitCreateOrUpdate(List<UnitCreateOrUpdateAction> actions, Iterable<String> playerOnMoveIds) {
    return ToClientMessage()
      ..message = OnClientAction.unitCreateOrUpdate
      ..content = json.encode((UnitCreateOrUpdate()
            ..playerOnMoveIds = playerOnMoveIds
            ..actions = actions)
          .toJson());
  }

  // ---

  UnitDelete get getUnitDelete => UnitDelete.fromJson(json.decode(content));

  factory ToClientMessage.fromUnitDelete(List<UnitDeleteAction> actions) {
    return ToClientMessage()
      ..message = OnClientAction.unitDelete
      ..content = json.encode((UnitDelete()..actions = actions).toJson());
  }

  // ---

  CancelOnField get getCancelOnField => CancelOnField.fromJson(json.decode(content));

  factory ToClientMessage.fromCancelOnField(List<CancelOnFieldAction> actions) {
    return ToClientMessage()
      ..message = OnClientAction.cancelOnField
      ..content = json.encode((CancelOnField()..actions = actions).toJson());
  }

  // ---

  IntentionUpdate get getIntentionUpdate => IntentionUpdate.fromJson(json.decode(content));

  factory ToClientMessage.fromIntentionUpdate(String playerId, List<String> trackFieldsId) {
    return ToClientMessage()
      ..message = OnClientAction.intentionUpdate
      ..content = json.encode((IntentionUpdate()
            ..playerId = playerId
            ..trackFieldsId = trackFieldsId)
          .toJson());
  }

  // ---
  //
  //  PlayersOnMove get getPlayersOnMove => PlayersOnMove.fromJson(json.decode(content));
  //
  //  factory ToClientMessage.fromPlayersOnMove(Iterable<String> playerOnMoveIds) {
  //    return ToClientMessage()
  //      ..message = OnClientAction.playersOnMove
  //      ..content = json.encode((PlayersOnMove()..playerOnMoveIds = playerOnMoveIds).toJson());
  //  }

  //  // ---
  //
  //  AddUnitType get getAddUnitType => AddUnitType.fromJson(json.decode(content));
  //
  //  factory ToClientMessage.fromAddUnitType(UnitTypeCompiled type) {
  //    return ToClientMessage()
  //      ..message = OnClientAction.addUnitType
  //      ..content = json.encode((AddUnitType()..type = type).toJson());
  //  }

  // ---

  Banter get getBanter => Banter.fromJson(json.decode(content));

  factory ToClientMessage.fromBanter(Banter banter) {
    return ToClientMessage()
      ..message = OnClientAction.showBanter
      ..content = json.encode(banter.toJson());
  }
}

@Typescript()
enum OnClientAction {
  @JsonValue('setNavigationState')
  setNavigationState,
  @JsonValue('refreshLobbyList')
  refreshLobbyList,
  @JsonValue('getGamesToCreate')
  getGamesToCreate,
  @JsonValue('setCurrentUser')
  setCurrentUser,
  @JsonValue('openedLobbyData')
  openedLobbyData,
  @JsonValue('taleData')
  taleData,
  @JsonValue('unitCreateOrUpdate')
  unitCreateOrUpdate,
  @JsonValue('unitDelete')
  unitDelete,
  @JsonValue('cancelOnField')
  cancelOnField,
  @JsonValue('intentionUpdate')
  intentionUpdate,
  @JsonValue('playersOnMove')
  playersOnMove,
  @JsonValue('addUnitType')
  addUnitType,
  @JsonValue('showBanter')
  showBanter
}

abstract class MessageContent {}

@JsonSerializable()
class SetNavigationState extends MessageContent {
  GameNavigationState newState;
  bool destroyCurrentTale = false;

  static SetNavigationState fromJson(Map<String, dynamic> json) => _$SetNavigationStateFromJson(json);

  Map<String, dynamic> toJson() {
    return _$SetNavigationStateToJson(this);
  }
}

@JsonSerializable()
class RefreshLobbyList extends MessageContent {
  List<OpenedLobby> lobbies;

  static RefreshLobbyList fromJson(Map<String, dynamic> json) => _$RefreshLobbyListFromJson(json);

  Map<String, dynamic> toJson() {
    return _$RefreshLobbyListToJson(this);
  }
}

@JsonSerializable()
class GetGamesToCreate extends MessageContent {
  List<LobbyTale> games;

  static GetGamesToCreate fromJson(Map<String, dynamic> json) => _$GetGamesToCreateFromJson(json);

  Map<String, dynamic> toJson() {
    return _$GetGamesToCreateToJson(this);
  }
}

@JsonSerializable()
class SetCurrentUser extends MessageContent {
  User user;

  static SetCurrentUser fromJson(Map<String, dynamic> json) => _$SetCurrentUserFromJson(json);

  Map<String, dynamic> toJson() {
    return _$SetCurrentUserToJson(this);
  }
}

@JsonSerializable()
class OpenedLobbyData extends MessageContent {
  OpenedLobby lobby;

  static OpenedLobbyData fromJson(Map<String, dynamic> json) => _$OpenedLobbyDataFromJson(json);

  Map<String, dynamic> toJson() {
    return _$OpenedLobbyDataToJson(this);
  }
}

@JsonSerializable()
class TaleData extends MessageContent {
  InitialTaleData data;

  static TaleData fromJson(Map<String, dynamic> json) => _$TaleDataFromJson(json);

  Map<String, dynamic> toJson() {
    return _$TaleDataToJson(this);
  }
}

@JsonSerializable()
class UnitCreateOrUpdate extends MessageContent {
  List<UnitCreateOrUpdateAction> actions;
  Iterable<String> playerOnMoveIds;

  static UnitCreateOrUpdate fromJson(Map<String, dynamic> json) => _$UnitCreateOrUpdateFromJson(json);

  Map<String, dynamic> toJson() {
    return _$UnitCreateOrUpdateToJson(this);
  }
}

@JsonSerializable()
class UnitDelete extends MessageContent {
  List<UnitDeleteAction> actions;

  static UnitDelete fromJson(Map<String, dynamic> json) => _$UnitDeleteFromJson(json);

  Map<String, dynamic> toJson() {
    return _$UnitDeleteToJson(this);
  }
}

@JsonSerializable()
class CancelOnField extends MessageContent {
  List<CancelOnFieldAction> actions;

  static CancelOnField fromJson(Map<String, dynamic> json) => _$CancelOnFieldFromJson(json);

  Map<String, dynamic> toJson() {
    return _$CancelOnFieldToJson(this);
  }
}

@JsonSerializable()
class IntentionUpdate extends MessageContent {
  String playerId;
  List<String> trackFieldsId;

  static IntentionUpdate fromJson(Map<String, dynamic> json) => _$IntentionUpdateFromJson(json);

  Map<String, dynamic> toJson() {
    return _$IntentionUpdateToJson(this);
  }
}

//@JsonSerializable()
//class PlayersOnMove extends MessageContent {
//  Iterable<String> playerOnMoveIds;
//
//  static PlayersOnMove fromJson(Map<String, dynamic> json) => _$PlayersOnMoveFromJson(json);
//
//  Map<String, dynamic> toJson() {
//    return _$PlayersOnMoveToJson(this);
//  }
//}
//
//@JsonSerializable()
//class AddUnitType extends MessageContent {
//  UnitTypeCompiled type;
//
//  static AddUnitType fromJson(Map<String, dynamic> json) => _$AddUnitTypeFromJson(json);
//
//  Map<String, dynamic> toJson() {
//    return _$AddUnitTypeToJson(this);
//  }
//}

@JsonSerializable()
class Banter extends MessageContent {
  int milliseconds;
  Image image;
  String text;

  static Banter fromJson(Map<String, dynamic> json) => _$BanterFromJson(json);

  Map<String, dynamic> toJson() {
    return _$BanterToJson(this);
  }
}
