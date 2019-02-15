part of model;

@JsonSerializable()
class ToGameServerMessage {
  OnServerAction message;
  String content;

  ToGameServerMessage();

  Map<String, dynamic> toJson() {
    return _$ToGameServerMessageToJson(this);
  }

  static ToGameServerMessage fromJson(Map<String, dynamic> json) =>
      _$ToGameServerMessageFromJson(json);

  // ---

  GoToState get goToStateMessage => GoToState.fromJson(json.decode(content));

  factory ToGameServerMessage.fromGoToState(GameNavigationState newState) {
    return ToGameServerMessage()
      ..message = OnServerAction.goToState
      ..content = json.encode((GoToState()..newState = newState).toJson());
  }

  // ---

  InitMessage get initMessage => InitMessage.fromJson(json.decode(content));

  factory ToGameServerMessage.init(String innerToken) {
    return ToGameServerMessage()
      ..content = jsonEncode((InitMessage()..innerToken = innerToken).toJson())
      ..message = OnServerAction.init;
  }

  // ---

  CreateLobby get createLobbyMessage =>
      CreateLobby.fromJson(json.decode(content));

  factory ToGameServerMessage.createLobby(String taleName, String roomName) {
    return ToGameServerMessage()
      ..content = jsonEncode((CreateLobby()
            ..taleName = taleName
            ..name = roomName)
          .toJson())
      ..message = OnServerAction.createLobby;
  }

  // ---

  EnterLobby get enterLobbyMessage =>
      EnterLobby.fromJson(json.decode(content));

  factory ToGameServerMessage.enterLobby(String lobbyId) {
    return ToGameServerMessage()
      ..content = jsonEncode((EnterLobby()
            ..lobbyId = lobbyId)
          .toJson())
      ..message = OnServerAction.enterLobby;
  }

  // ---

  EnterGame get enterGameMessage =>
      EnterGame.fromJson(json.decode(content));

  factory ToGameServerMessage.enterGame(String lobbyId) {
    return ToGameServerMessage()
      ..content = jsonEncode((EnterGame()
            ..lobbyId = lobbyId)
          .toJson())
      ..message = OnServerAction.enterGame;
  }
  // ---

  PlayerGameAction get playerGameActionMessage =>
      PlayerGameAction.fromJson(json.decode(content));

  factory ToGameServerMessage.playerGameAction(String lobbyId) {
    return ToGameServerMessage()
      ..content = jsonEncode((PlayerGameAction()
            ..lobbyId = lobbyId)
          .toJson())
      ..message = OnServerAction.playerGameAction;
  }
}

@Typescript()
enum OnServerAction {
  @JsonValue('goToState')
  goToState,
  @JsonValue('init')
  init,
  @JsonValue('createLobby')
  createLobby,
  @JsonValue('enterLobby')
  enterLobby,
  @JsonValue('enterGame')
  enterGame,
  @JsonValue('playerGameAction')
  playerGameAction,
}

@JsonSerializable()
class GoToState extends MessageContent {
  GameNavigationState newState;

  static GoToState fromJson(Map<String, dynamic> json) =>
      _$GoToStateFromJson(json);

  Map<String, dynamic> toJson() {
    return _$GoToStateToJson(this);
  }
}

@JsonSerializable()
class InitMessage extends MessageContent {
  String innerToken;

  static InitMessage fromJson(Map<String, dynamic> json) =>
      _$InitMessageFromJson(json);

  Map<String, dynamic> toJson() {
    return _$InitMessageToJson(this);
  }
}

@JsonSerializable()
class CreateLobby extends MessageContent {
  String taleName;
  String name;

  static CreateLobby fromJson(Map<String, dynamic> json) =>
      _$CreateLobbyFromJson(json);

  Map<String, dynamic> toJson() {
    return _$CreateLobbyToJson(this);
  }
}

@JsonSerializable()
class EnterLobby extends MessageContent {
  String lobbyId;
  static EnterLobby fromJson(Map<String, dynamic> json) =>
      _$EnterLobbyFromJson(json);

  Map<String, dynamic> toJson() {
    return _$EnterLobbyToJson(this);
  }
}

@JsonSerializable()
class EnterGame extends MessageContent {
  String lobbyId;
  static EnterGame fromJson(Map<String, dynamic> json) =>
      _$EnterGameFromJson(json);

  Map<String, dynamic> toJson() {
    return _$EnterGameToJson(this);
  }
}

@JsonSerializable()
class PlayerGameAction extends MessageContent {
  String lobbyId;
  static PlayerGameAction fromJson(Map<String, dynamic> json) =>
      _$PlayerGameActionFromJson(json);

  Map<String, dynamic> toJson() {
    return _$PlayerGameActionToJson(this);
  }
}
