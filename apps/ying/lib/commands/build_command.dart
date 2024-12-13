import 'dart:io';

import 'package:result_type/result_type.dart';
import 'package:ying_shared/cli/command.dart';
import 'package:ying_shared/cli/command_execution_context.dart';
import 'package:ying_shared/cli/flag.dart';
import 'package:ying_shared/languages/yang/parser.dart';
import 'package:ying_shared/logging/logger.dart';
import 'package:ying_shared/source_file.dart';

class BuildCommand extends Command {
  final Logger logger = Logger.withSimpleNameFromEnv("build");

  BuildCommand()
      : super("build", [], [], [
          FileFlag("entrypoint", ["e"], true, true),
        ]);

  @override
  void execute(CommandExecutionContext commandExecutionContext) async {
    final File entrypoint = commandExecutionContext.parsedFlags["entrypoint"];

    if (entrypoint.existsSync() == false) {
      logger.error("File ${entrypoint.absolute.path} does not exist");

      return;
    }

    final sourceFile = await SourceFile.readFromPath(entrypoint.absolute.path);

    switch (YangFrontend.parseFromSourceFile(sourceFile)) {
      case Success(value: var parsedStatements):
        logger.debug("Result: $parsedStatements");
        break;

      case Failure(failure: var reason):
        logger.error("Could not parse ${sourceFile.uri}: $reason");
        return;
    }
  }
}
