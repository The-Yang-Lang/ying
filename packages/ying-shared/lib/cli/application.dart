import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:ying_shared/cli/errors.dart';
import 'package:ying_shared/logging/logger.dart';
import 'package:ying_shared/utils/string.dart';
import 'package:ying_shared/utils/stringify.dart';

import 'command.dart';
import 'command_execution_context.dart';

class Application {
  /// The name of the CLI application
  String? name;

  /// The version of the CLI application
  String version;

  /// The optional description of the CLI application
  String? description;

  /// All registered commands for the CLI application
  List<Command> commands;

  Logger logger = Logger.withSimpleNameFromEnv("Application");

  /// Creates a new instance of the CLI application with the given name, version
  /// and optional description.
  Application(this.version, {this.name, this.description}) : commands = [];

  /// Creates a new instance of the CLI application with the given name,
  /// version, commands and optional description.
  Application.withCommands(
    this.version,
    this.commands, {
    this.name,
    this.description,
  });

  String get executableName => name ?? Platform.executable;

  Future<void> run(List<String> programArguments) async {
    switch (findCommandRecursively(commands, programArguments)) {
      case null:
        if (description != null) {
          print("$executableName - $description");
        } else {
          print(executableName);
        }

        print("");

        if (commands.isEmpty) {
          print("No commands available");

          return;
        }

        print("Available commands:");

        final longestCommandName = commands.fold(
          0,
          (acc, command) => max(acc, command.name.length),
        );

        final terminalColumns = stdout.hasTerminal
            ? stdout.terminalColumns
            : double.maxFinite.toInt();

        for (final command in commands) {
          if (command.description == null) {
            print(command.name);
            continue;
          }

          final name = command.name.padRight(longestCommandName);
          final description = wrapText(
            command.description!,
            terminalColumns,
          );

          print(
            "$name | $description",
          );
        }

        break;
      case (final foundCommands, final commandArguments):
        final commandToRun = foundCommands.last;

        CommandExecutionContext commandExecutionContext;

        try {
          commandExecutionContext = createCommandExecutionContext(
            commandToRun,
            commandArguments,
          );
        } catch (error) {
          switch (error) {
            case InvalidBooleanArgumentError e:
              logger.error(
                "Could not parse argument ${e.argument.name}: invalid input. Expected 'true' or 'false'. Got: ${stringify(e.value)}",
              );
              break;

            case InvalidIntegerArgumentError e:
              logger.error(
                "Could not parse argument ${e.argument.name}: invalid input. Expected a parsable integer representation. Got: ${stringify(e.value)}",
              );
              break;

            case InvalidDoubleArgumentError e:
              logger.error(
                "Could not parse argument ${e.argument.name}: invalid input. Expected a parsable double representation. Got: ${stringify(e.value)}",
              );
              break;

            case InvalidFilePathArgumentError e:
              logger.error(
                "Could not parse argument ${e.argument.name}: invalid input. Expected a path to an existing file. Got: ${stringify(e.value)}",
              );
              break;

            case InvalidDirectoryPathArgumentError e:
              logger.error(
                "Could not parse argument ${e.argument.name}: invalid input. Expected a path to an existing directory. Got: ${stringify(e.value)}",
              );
              break;

            case InvalidBooleanFlagError e:
              logger.error(
                "Could not parse flag ${e.flag.name}: invalid input. Expected 'true' or 'false'. Got: ${stringify(e.value)}",
              );
              break;

            case InvalidStringFlagError e:
              logger.error(
                "Could not parse flag ${e.flag.name}: invalid input. Expected a string. Got: ${stringify(e.value)}",
              );
              break;

            case InvalidIntegerFlagError e:
              logger.error(
                "Could not parse flag ${e.flag.name}: invalid input. Expected a parsable integer representation. Got: ${stringify(e.value)}",
              );
              break;

            case InvalidDoubleFlagError e:
              logger.error(
                "Could not parse flag ${e.flag.name}: invalid input. Expected a parsable double representation. Got: ${stringify(e.value)}",
              );
              break;

            case InvalidFilePathFlagError e:
              logger.error(
                "Could not parse flag ${e.flag.name}: invalid input. Expected a path to an existing file. Got: ${stringify(e.value)}",
              );
              break;

            case InvalidDirectoryPathFlagError e:
              logger.error(
                "Could not parse flag ${e.flag.name}: invalid input. Expected a path to an existing directory. Got: ${stringify(e.value)}",
              );
              break;

            case UnparsedRequiredArgumentsError e:
              final names = e.unparsedArguments
                  .map((argument) => argument.name)
                  .join(", ");

              logger.error("Missing required arguments: $names");
              break;

            case UnparsedRequiredFlagsError e:
              final names = e.unparsedFlags.map((flag) => flag.name).join(", ");

              logger.error("Missing required flags: $names");
              break;
          }

          printCommandHelp(foundCommands);

          return;
        }

        try {
          await commandToRun.execute(commandExecutionContext);
        } catch (error) {
          print(
            "An unexpected error occurred while executing command '${commandToRun.name}': $error",
          );
        }
    }
  }

  void printCommandHelp(List<Command> commands) {
    if (description != null) {
      print("$executableName - $description");
    } else {
      print(executableName);
    }

    print("");

    final commandsPath = commands.map((command) => command.name).join(" ");

    print("$executableName $commandsPath");

    print(getCommandHelpString(commands.last));
  }
}
