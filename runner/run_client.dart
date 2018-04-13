import 'dart:io';
import 'package:io_utils/io_utils.dart';
import 'common.dart';

main() async{
  String projectDirectoryPath = harmonizePath();
  print("OPEN BROWSER ON http://localhost:8080");

  Process.start(pubExecutable,
      ["serve", "--port=8085"],
    workingDirectory: projectDirectoryPath + "/client"
  ).then((Process process) {
    printFromOutputStreams(process, "Pub serve", "gold");
  });

  Process.start(dartExecutable,
      ["web_server.dart"],
      workingDirectory: projectDirectoryPath + "/runner")
      .then((Process process) {
        process.stdout.listen((_){
          // have to be listened or process will end
        });
//    printFromOutputStreams(process, "web_server", "green");
  });

}