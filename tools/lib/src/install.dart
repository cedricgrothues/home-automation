import 'package:args/command_runner.dart';

class InstallCommand extends Command {
  final name = "install";
  final description = "Install the home-automation server to a new Raspberry Pi.";

  InstallCommand() {
    argParser.addFlag('all', abbr: 'a');
  }

  void run() {
    print(argResults['all']);
  }
}
