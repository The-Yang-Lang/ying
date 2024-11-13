import 'package:ying_shared/cli/argument.dart';
import 'package:ying_shared/cli/command.dart';
import 'package:ying_shared/cli/command_execution_context.dart';
import 'package:ying_shared/cli/flag.dart';
import 'package:ying_shared/logging/logger.dart';

class InitCommand extends Command {
  final Logger logger = Logger.withSimpleNameFromEnv("init");

  InitCommand()
      : super(
          "init",
          [],
          [
            DirectoryArgument(
              "directory",
              true,
              false,
              description:
                  "The directory where the new project will be initialized in",
            ),
          ],
          [
            StringFlag(
              "name",
              [],
              false,
              description: "The name of the package to create",
            ),
            StringFlag(
              "version",
              [],
              false,
              description: "The version of the package to create",
            ),
            StringFlag(
              "license",
              [],
              false,
              description: "The license of the package to create",
            ),
          ],
          description: "Initializes a new Ying project",
        );

  @override
  void execute(CommandExecutionContext commandExecutionContext) {
    logger.debug("Running the init command: $commandExecutionContext");
  }
}
