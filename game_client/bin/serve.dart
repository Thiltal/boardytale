import 'package:shared/configuration/configuration.dart';
import 'package:io_utils/io_utils.dart';
import 'dart:io';
import 'dart:async';

Future main() async {
  final BoardytaleConfiguration boardytaleConfiguration = getConfiguration();
  String projectDirectoryPath = getProjectDirectory().path;

  print("running on ${boardytaleConfiguration.gameStaticDev.port}");

  Process.start("webdev",
          ["serve", "web:${boardytaleConfiguration.gameStaticDev.port}"],
          runInShell: true,
          workingDirectory: "${projectDirectoryPath}/game_client")
      .then((Process process) {
    printFromOutputStreams(process, "game serve", "light_cyan");
  });
}
