part of game_server;

class ServerTaleState {
  final ServerTale tale;
  String taleId;
  core.TaleInnerCompiled compiled;
  core.Assets assets = core.Assets();
  Map<String, core.Unit> units = {};
  Map<String, ServerPlayer> players = {};
  Map<String, ServerPlayer> humanPlayers = {};
  Map<String, ServerPlayer> aiPlayers = {};
  Map<String, core.UnitType> unitTypes = {};
  Map<String, core.Field> fields;
  List<String> playerOnMoveIds = [];
  bool gameStared = false;

  List<TaleAction> actionLog = [];

  ServerTaleState(this.compiled, this.tale) {
    taleId = DateTime.now().toIso8601String().replaceAll(":", "-");
    compiled.unitTypes.forEach((String name, core.UnitTypeCompiled unitType) {
      unitTypes[name] = core.UnitType()..fromCompiled(unitType, assets);
    });
    fields = core.World.createFields(compiled.world, (key) => core.Field(key));
  }

  core.Tale createTaleForPlayer(ServerPlayer player) {
    return core.Tale.fromCompiledTale(compiled)
      ..units = units.values.map((unit) => unit.getUnitCreateOrUpdateAction()).toList()
      ..unitTypes = unitTypes
      ..playerOnMoveIds = playerOnMoveIds
      ..players = players.map((key, player) => MapEntry(key, player.createGamePlayer()));
  }

  void addTaleAction(TaleAction action) {
    if (action == null) {
      // invalid unit track actions handled another way
      return null;
    }
    // TODO: detect something is changed, don't send messages otherwise. See core.Unit
    actionLog.add(action);
    core.TaleUpdate outputTaleUpdate = core.TaleUpdate();
    action.newPlayersToTale.forEach((player) {
      players[player.id] = player;
      if (player.aiGroup != null) {
        aiPlayers[player.id] = player;
      } else {
        humanPlayers[player.id] = player;
      }
    });
    outputTaleUpdate.newPlayersToTale = action.newPlayersToTale.map((player) => player.createGamePlayer()).toList();
    if (action.playersOnMove != null) {
      playerOnMoveIds = action.playersOnMove;
    }

    action.newUnitTypesToTale.forEach((core.UnitType type) {
      unitTypes[type.name] = type;
    });
    outputTaleUpdate.newUnitTypesToTale = action.newUnitTypesToTale;

    if (action.newAssetsToTale != null) {
      assets.merge(action.newAssetsToTale);
      outputTaleUpdate.newAssetsToTale = action.newAssetsToTale;
    }

    if (action.unitUpdates != null) {
      List<core.UnitCreateOrUpdateAction> actionsWithEffect = [];
      action.unitUpdates.forEach((core.UnitCreateOrUpdateAction action) {
        if (units.containsKey(action.unitId)) {
          core.Unit unit = units[action.unitId];
          var report = unit.addUnitUpdateAction(action, fields[action.moveToFieldId]);
          if (report != null) {
            actionsWithEffect.add(action);
            tale.events.setUnitReport(report);
          }
        } else {
          core.Unit unit = core.Unit(createServerAbilityList, action, fields, players, unitTypes);
          units[unit.id] = unit;
          actionsWithEffect.add(action);
        }
      });
      outputTaleUpdate.actions = actionsWithEffect;
    }

    outputTaleUpdate.playerOnMoveIds = playerOnMoveIds;

    if (action.removePlayerId != null) {
      outputTaleUpdate.removePlayerId = action.removePlayerId;
      humanPlayers.remove(action.removePlayerId);
      outputTaleUpdate.unitToRemoveIds = [];
      units.forEach((id, unit) {
        if (unit.player.id == action.removePlayerId) {
          outputTaleUpdate.unitToRemoveIds.add(id);
        }
      });
      outputTaleUpdate.unitToRemoveIds.forEach((idToRemove) {
        units.remove(idToRemove);
      });
      players.remove(action.removePlayerId);
    }

    if (action.banterAction != null) {
      outputTaleUpdate.banterAction = action.banterAction;
    }

    Logger.log(taleId, core.LoggerMessage.fromTaleUpdate(outputTaleUpdate));
    if (gameStared) {
      tale.sendMessages(outputTaleUpdate);
    }
  }
}
