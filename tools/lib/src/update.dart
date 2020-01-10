import 'package:args/command_runner.dart';

class UpdateCommand extends Command {
  final name = "update";
  final description = "Update an existing Raspberry Pi.";

  UpdateCommand() {
    argParser.addFlag('all', abbr: 'a');
  }

  void run() {
    print(argResults['all']);
  }
}
