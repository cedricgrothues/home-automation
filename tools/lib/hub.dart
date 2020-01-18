import 'dart:io';

import 'package:args/command_runner.dart';

import 'package:hub/src/install.dart';
import 'package:hub/src/update.dart';

void main(List<String> args) {
  CommandRunner runner = CommandRunner("hub", "Home Hub Controller")
    ..addCommand(new UpdateCommand())
    ..addCommand(new InstallCommand());

  runner.run(args).catchError((error) {
    print(runner.usage);
    exit(64);
  });
}
