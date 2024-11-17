import 'package:ying_shared/cli/command.dart';
import 'package:ying_shared/cli/errors.dart';
import 'package:ying_shared/cli/flag.dart';
import 'package:ying_shared/utils/stringify.dart';

final flagPattern = RegExp(
  r"^(?<dashes>-{1,2})(?<name>\w+)(=(?<value>.*))?$",
  dotAll: false,
);

/// Tries to split the given [input] into a flag name and its associated value.
///
/// The returned tuple is structured as follows:
/// bool - True when the flag contains two dashes, false otherwise.
/// String - The flag name.
/// String - The flag value
(bool, String, String?)? _splitFlag(String input) {
  switch (flagPattern.firstMatch(input)) {
    case final RegExpMatch match:
      final dashes = match.namedGroup("dashes");
      final flagName = match.namedGroup("name");
      final flagValue = match.namedGroup("value");

      return (dashes!.length == 2, flagName!, flagValue);

    default:
      return null;
  }
}

CommandExecutionContext createCommandExecutionContext(
  Command command,
  List<String> commandArguments,
) {
  final parsedArguments = <String, dynamic>{};
  final parsedFlags = <String, dynamic>{};

  final unparsedArguments = command.arguments;
  final unparsedFlags = command.flags;

  for (var argumentIndex = 0;
      argumentIndex < commandArguments.length;
      argumentIndex++) {
    final currentArgument = commandArguments[argumentIndex];

    switch (_splitFlag(currentArgument)) {
      case null:
        // Handle current argument as command argument

        switch (unparsedArguments.firstOrNull) {
          case null:
            // Extranous argument
            continue;
          case final commandArgument:
            unparsedArguments.removeAt(0);

            parsedArguments[commandArgument.name] = commandArgument.parse(
              currentArgument,
            );
            break;
        }
        break;

      case (final isFullName, final flagName, final flagValue):
        final foundFlag = unparsedFlags
            .where(
              (flag) =>
                  (isFullName && flag.name == flagName) ||
                  (isFullName == false && flag.aliases.contains(flagName)),
            )
            .firstOrNull;

        if (foundFlag == null) {
          // Unrecognized flag

          continue;
        }

        if (flagValue == null) {
          switch (foundFlag) {
            case BoolFlag _:
              parsedFlags[foundFlag.name] = true;

              unparsedFlags.remove(foundFlag);
              break;
            case StringFlag _:
              throw InvalidStringFlagError(foundFlag, null);
            case IntegerFlag _:
              throw InvalidIntegerFlagError(foundFlag, null);
            case DoubleFlag _:
              throw InvalidDoubleFlagError(foundFlag, null);
            case FileFlag _:
              throw InvalidFilePathFlagError(foundFlag, null);
            case DirectoryFlag _:
              throw InvalidDirectoryPathFlagError(foundFlag, null);
          }
        } else {
          parsedFlags[foundFlag.name] = foundFlag.parse(flagValue);

          unparsedFlags.remove(foundFlag);
        }
        break;
    }
  }

  final booleanFlags = unparsedFlags.whereType<BoolFlag>().toList();

  for (final booleanFlag in booleanFlags) {
    parsedFlags[booleanFlag.name] = false;
    unparsedFlags.remove(booleanFlag);
  }

  final unparsedRequiredArguments = unparsedArguments
      .where(
        (unparsedArgument) => unparsedArgument.isRequired,
      )
      .toList();

  if (unparsedRequiredArguments.isNotEmpty) {
    throw UnparsedRequiredArgumentsError(unparsedRequiredArguments);
  }

  final unparsedRequiredFlags = unparsedFlags
      .where(
        (flag) => flag.isRequired,
      )
      .toList();

  if (unparsedRequiredFlags.isNotEmpty) {
    throw UnparsedRequiredFlagsError(unparsedRequiredFlags);
  }

  return CommandExecutionContext(parsedArguments, parsedFlags);
}

class CommandExecutionContext {
  /// Contains the values for the parsed arguments
  final Map<String, dynamic> parsedArguments;

  /// Contains the values for the parsed flags
  final Map<String, dynamic> parsedFlags;

  /// Creates a new instance of the CommandExecutionContext with the given
  /// parsed arguments and flags
  CommandExecutionContext(this.parsedArguments, this.parsedFlags);

  @override
  String toString() {
    return stringifyInstance("CommandExecutionContext", {
      "parsedArguments": parsedArguments,
      "parsedFlags": parsedFlags,
    });
  }
}
