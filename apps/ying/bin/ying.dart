import 'package:ying/commands/init_command.dart';
import 'package:ying_shared/cli/application.dart';
import 'package:ying_shared/logging/logger.dart';
import 'package:ying_shared/utils/stringify.dart';

void main(List<String> arguments) {
  final logger = Logger.withSimpleNameFromEnv("Main");

  logger.debug(
    "Got the following program arguments: ${stringify(arguments)}",
  );

  final application = Application.withCommands(
    name: "ying",
    description: "The official CLI for the Yang language",
    "0.0.0",
    [InitCommand()],
  );

  application.run(arguments);
}
