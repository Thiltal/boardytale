part of game_server;

class CreateGameService {
  Future<List<shared.LobbyTale>> getGamesToCreate() async {
    String uri =
        makeAddressFromUri(config.editorServer.uris.first) + "inner/lobbyList";
    print(uri);
    http.Response response =
        await http.get(uri, headers: {"Content-Type": "application/json"});
    List<shared.LobbyTale> lobbies = [];
    (jsonDecode(response.body) as List).forEach((lobbyTaleData) {
      lobbies.add(shared.LobbyTale.fromJson(lobbyTaleData));
    });
    return lobbies;
  }

  void sendGamesToCreate(ServerPlayer player) async {
    gateway.sendMessage(
        shared.ToClientMessage.fromGamesToCreateMessage(
            await createGameService.getGamesToCreate()),
        player);
  }
}
