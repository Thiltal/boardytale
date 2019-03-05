part of game_server;

class ServerTale {
  static const colors = const [
    Color.Red,
    Color.Blue,
    Color.Green,
    Color.Yellow
  ];
  LobbyRoom room;

  BehaviorSubject<shared.UnitUpdateReport> onReport = BehaviorSubject<shared.UnitUpdateReport>();
  Map<String, ServerPlayer> get players => room.connectedPlayers;
  shared.ClientTaleData taleData;
  shared.Tale sharedTale;
  Map<String, shared.UnitType> unitTypes = {};
  Map<String, ServerUnit> units = {};
  int _lastUnitId = 0;

  ServerTale(this.room) {
    int index = 0;
    sharedTale = shared.Tale()..fromCompiledTale(room.compiledTale.tale);
    taleData = shared.ClientTaleData.fromCompiledTale(room.compiledTale.tale);
    players.values.forEach((player) {
      player.color = ServerTale.colors[index++];
    });

    List<shared.Player> gamePlayers = [];
    players.values.forEach((player) {
      gamePlayers.add(player.createGamePlayer());
    });

    taleData.players = gamePlayers;

    players.values.forEach((player) {
      taleData.playerIdOnThisClientMachine = player.id;
      gateway.sendMessage(
          shared.ToClientMessage.fromTaleData(taleData), player);
    });

    room.compiledTale.tale.assets.unitTypes
        .forEach((String name, shared.UnitTypeCompiled unitType) {
      unitTypes[name] = shared.UnitType()..fromCompiledUnitType(unitType);
    });

    room.compiledTale.tale.units.forEach((unitCreateEnvelope) {
      shared.UnitType unitType = unitTypes[unitCreateEnvelope.unitTypeName];
      String unitId = "${_lastUnitId++}";
      ServerUnit unit = ServerUnit()
        ..fromUnitType(unitType,
            sharedTale.world.fields[unitCreateEnvelope.fieldId], unitId);
      if (unitCreateEnvelope.aiGroupId != null) {
        unit.aiGroupId = unitCreateEnvelope.aiGroupId;
      } else {
        unit.player = players[unitCreateEnvelope.playerId];
      }
      units[unitId] = unit;
    });

    Future.delayed(Duration(milliseconds: 10)).then((onValue) {
      sendInitialUnits();
    });
  }

  void sendInitTaleDataToPlayer(ServerPlayer player) {
    taleData.playerIdOnThisClientMachine = player.id;
    gateway.sendMessage(shared.ToClientMessage.fromTaleData(taleData), player);
    sendInitialUnits();
  }

  void handleUnitTrack(MessageWithConnection message) {
    shared.UnitTrackAction action = message.message.unitTrackActionMessage;
    ServerUnit unit = units[action.unitId];
    shared.Track track = shared.Track(
        action.track.map((f) => sharedTale.world.fields[f]).toList());
    shared.AbilityName name = action.abilityName;
    unit.perform(name, track, action, this);
  }

  void sendInitialUnits() {
    // TODO: implement line of sight here

    List<shared.UnitCreateOrUpdateAction> actions = [];
    units.forEach((id, unit) {
      actions.add(shared.UnitCreateOrUpdateAction()
        ..unitId = unit.id
        ..state = (unit.getState()
        ..moveToFieldId = unit.field.id
            ..transferToPlayerId = unit.player?.id
            ..transferToAiGroupId = unit.aiGroupId
            ..changeToTypeName = unit.type.name
        )
      );
    });

    players.values.forEach((player) {
      gateway.sendMessage(
          shared.ToClientMessage.fromUnitCreateOrUpdate(actions), player);
    });
  }

  void sendNewState(shared.UnitCreateOrUpdateAction action) {
    players.values.forEach((player) {
      gateway.sendMessage(
          shared.ToClientMessage.fromUnitCreateOrUpdate([action]), player);
    });
  }

  void endOfTurn(MessageWithConnection message) {
    List<shared.UnitCreateOrUpdateAction> actions = [];
    units.forEach((key, unit) {
      if (unit.newTurn()) {
        actions.add(shared.UnitCreateOrUpdateAction()
          ..unitId = unit.id
          ..state = (shared.LiveUnitState()..fromUnit(unit)));
      }
    });
    players.values.forEach((player) {
      gateway.sendMessage(
          shared.ToClientMessage.fromUnitCreateOrUpdate(actions), player);
    });
  }
}
