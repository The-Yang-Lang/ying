import 'dart:async';
import 'dart:io';

import 'package:ying_shared/cli/errors.dart';
import 'package:ying_shared/utils/table.dart';
import 'package:ying_shared/utils/table/column_mapping.dart';
import 'package:ying_shared/utils/table/text_alignment.dart';

import 'argument.dart';
import 'command_execution_context.dart';
import 'flag.dart';

/// Tries to find a (sub-)command based on the given arguments.
///
/// It returns null in the following cases:
/// - the given commands are empty
/// - the given arguments are empty
/// - no command was matched by their name based on the first argument
(List<Command>, List<String>)? findCommandRecursively(
  List<Command> commands,
  List<String> arguments,
) {
  if (commands.isEmpty) {
    return null;
  }

  if (arguments.isEmpty) {
    return null;
  }

  final nameToFind = arguments.first;
  final foundCommands = commands.where((command) => command.name == nameToFind);

  if (foundCommands.isEmpty) {
    return null;
  }

  final foundCommand = foundCommands.first;
  final commandArguments = arguments.skip(1).toList();

  switch (findCommandRecursively(foundCommand.subCommands, commandArguments)) {
    case null:
      return ([foundCommand], commandArguments);

    case (final foundSubCommands, final subCommandArguments):
      return ([foundCommand, ...foundSubCommands], subCommandArguments);
  }
}

String getCommandHelpString(Command command) {
  final mappedArguments = command.arguments.map((argument) {
    switch (argument) {
      case BoolArgument castedArgument:
        return {
          "name": castedArgument.name,
          "type": "boolean",
          "description": castedArgument.description ?? "",
          "isRequired": castedArgument.isRequired.toString(),
        };
      case StringArgument castedArgument:
        return {
          "name": castedArgument.name,
          "type": "string",
          "description": castedArgument.description ?? "",
          "isRequired": castedArgument.isRequired.toString(),
        };

      case IntegerArgument castedArgument:
        return {
          "name": castedArgument.name,
          "type": "integer",
          "description": castedArgument.description ?? "",
          "isRequired": castedArgument.isRequired.toString(),
        };
      case DoubleArgument castedArgument:
        return {
          "name": castedArgument.name,
          "type": "double",
          "description": castedArgument.description ?? "",
          "isRequired": castedArgument.isRequired.toString(),
        };
      case FileArgument castedArgument:
        return {
          "name": castedArgument.name,
          "type": "file path",
          "description": castedArgument.description ?? "",
          "isRequired": castedArgument.isRequired.toString(),
          "mustExist": castedArgument.mustExist.toString(),
        };
      case DirectoryArgument castedArgument:
        return {
          "name": castedArgument.name,
          "type": "directory path",
          "description": castedArgument.description ?? "",
          "isRequired": castedArgument.isRequired.toString(),
          "mustExist": castedArgument.mustExist.toString(),
        };
      default:
        throw UnknownArgumentError(argument);
    }
  }).toList();

  final mappedFlags = command.flags.map((flag) {
    switch (flag) {
      case BoolFlag castedFlag:
        return {
          "name": castedFlag.name,
          "type": "boolean",
          "aliases": castedFlag.aliases.join(", "),
          "description": castedFlag.description ?? "",
          "isRequired": castedFlag.isRequired.toString(),
        };

      case StringFlag castedFlag:
        return {
          "name": castedFlag.name,
          "type": "string",
          "aliases": castedFlag.aliases.join(", "),
          "description": castedFlag.description ?? "",
          "isRequired": castedFlag.isRequired.toString(),
        };

      case IntegerFlag castedFlag:
        return {
          "name": castedFlag.name,
          "type": "integer",
          "aliases": castedFlag.aliases.join(", "),
          "description": castedFlag.description ?? "",
          "isRequired": castedFlag.isRequired.toString(),
        };

      case DoubleFlag castedFlag:
        return {
          "name": castedFlag.name,
          "type": "double",
          "aliases": castedFlag.aliases.join(", "),
          "description": castedFlag.description ?? "",
          "isRequired": castedFlag.isRequired.toString(),
        };

      case FileFlag castedFlag:
        return {
          "name": flag.name,
          "type": "file path",
          "aliases": flag.aliases.join(", "),
          "description": flag.description ?? "",
          "isRequired": flag.isRequired.toString(),
          "mustExist": castedFlag.mustExist.toString(),
        };
      case DirectoryFlag castedFlag:
        return {
          "name": flag.name,
          "type": "directory path",
          "aliases": flag.aliases.join(", "),
          "description": flag.description ?? "",
          "isRequired": flag.isRequired.toString(),
          "mustExist": castedFlag.mustExist.toString(),
        };
      default:
        throw UnknownFlagError(flag);
    }
  }).toList();

  final result = StringBuffer();
  final maxWidth =
      stdout.hasTerminal ? stdout.terminalColumns : double.maxFinite.toInt();

  if (mappedArguments.isNotEmpty) {
    result.writeln(
      generateTable(
        mappings: {
          "name": ColumnMapping(title: "Name"),
          "type": ColumnMapping(title: "Type"),
          "isRequired": ColumnMapping(title: "Required"),
          "mustExist": ColumnMapping(title: "Path must exist"),
          "description": ColumnMapping(title: "Description"),
        },
        rows: mappedArguments,
        maximumWidth: maxWidth,
        header: ColumnMapping(
          title: "Available arguments",
          alignment: TextAlignment.center,
        ),
        removeEmptyColumns: true,
      ),
    );
  }

  if (mappedFlags.isNotEmpty) {
    result.writeln(
      generateTable(
        mappings: {
          "name": ColumnMapping(title: "Name"),
          "type": ColumnMapping(title: "Type"),
          "aliases": ColumnMapping(title: "Aliases"),
          "isRequired": ColumnMapping(title: "Required"),
          "mustExist": ColumnMapping(title: "Path must exist"),
          "description": ColumnMapping(title: "Description"),
        },
        rows: mappedFlags,
        maximumWidth: maxWidth,
        header: ColumnMapping(
          title: "Available flags",
          alignment: TextAlignment.center,
        ),
        removeEmptyColumns: true,
      ),
    );
  }

  return result.toString();
}

abstract class Command {
  /// The name of the command
  String name;

  /// The optional description of the command
  String? description;

  /// The aliases for the command
  List<String> aliases;

  /// Optional sub commands for the command
  List<Command> subCommands;

  /// The parsable arguments of the command
  List<Argument<dynamic>> arguments;

  /// The parsable flags of the command
  List<Flag<dynamic>> flags;

  /// Creates a new instance of the command with the given name, aliases
  /// and optional description.
  Command(
    this.name,
    this.aliases,
    this.arguments,
    this.flags, {
    this.description,
  }) : subCommands = [];

  /// Creates a new instance of the command with the given name, aliases,
  /// sub commands and optional description.
  Command.withSubCommands(
    this.name,
    this.aliases,
    this.arguments,
    this.flags,
    this.subCommands, {
    this.description,
  });

  /// Gets called when the command was determined to run
  FutureOr<void> execute(CommandExecutionContext commandExecutionContext);
}
