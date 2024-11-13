import 'package:test/test.dart';
import 'package:ying_shared/cli/argument.dart';
import 'package:ying_shared/cli/command.dart';
import 'package:ying_shared/cli/command_execution_context.dart';
import 'package:ying_shared/cli/errors.dart';
import 'package:ying_shared/cli/flag.dart';

class SubCommand extends Command {
  SubCommand()
      : super.withSubCommands(
          "sub",
          [],
          [],
          [],
          [],
        );

  @override
  void execute(CommandExecutionContext _) {}
}

class RootCommand extends Command {
  RootCommand()
      : super.withSubCommands(
          "root",
          [],
          [],
          [],
          [SubCommand()],
        );

  @override
  void execute(CommandExecutionContext _) {}
}

class UnknownArgument extends Argument {
  UnknownArgument(super.name, super.isRequired);

  @override
  parse(String value) {
    throw UnimplementedError();
  }
}

class UnknownFlag extends Flag {
  UnknownFlag(super.name, super.aliases, super.isRequired);

  @override
  parse(String value) {
    throw UnimplementedError();
  }
}

void main() {
  group('Command', () {
    group('findCommandRecursively', () {
      test('it should return null when no commands were given', () {
        expect(findCommandRecursively([], []), null);
      });

      test('it should return null when no arguments were given', () {
        expect(findCommandRecursively([RootCommand()], []), null);
      });

      test(
        'it should return null when no command matches the first argument',
        () {
          expect(findCommandRecursively([RootCommand()], ["unit"]), null);
        },
      );

      test(
        'it should return the found top-level command when the first argument matches its name',
        () {
          final result = findCommandRecursively([RootCommand()], ["root"]);

          expect(result != null, true);

          final (foundCommands, commandArguments) = result!;

          expect(foundCommands, hasLength(1));
          expect(foundCommands.lastOrNull?.name, "root");
          expect(commandArguments, []);
        },
      );

      test(
        'it should return the found top-level command including the trailing arguments when the first argument matches its name',
        () {
          final result = findCommandRecursively(
            [RootCommand()],
            ["root", "unit", "test"],
          );

          expect(result != null, true);

          final (foundCommands, commandArguments) = result!;

          expect(foundCommands, hasLength(1));
          expect(foundCommands.lastOrNull?.name, "root");
          expect(commandArguments, ["unit", "test"]);
        },
      );

      test('it should return the found subcommand', () {
        final result = findCommandRecursively(
          [RootCommand()],
          ["root", "sub"],
        );

        expect(result != null, true);

        final (foundCommands, commandArguments) = result!;

        expect(foundCommands, hasLength(2));
        expect(
          foundCommands.lastOrNull?.name,
          "sub",
        );
        expect(commandArguments, []);
      });

      test(
          'it should return the found subcommand including the trailing arguments',
          () {
        final result = findCommandRecursively(
          [RootCommand()],
          ["root", "sub", "unit", "test"],
        );

        expect(result != null, true);

        final (foundCommands, commandArguments) = result!;

        expect(foundCommands, hasLength(2));
        expect(foundCommands.lastOrNull?.name, "sub");
        expect(commandArguments, ["unit", "test"]);
      });
    });

    group('getCommandHelpString', () {
      group('arguments', () {
        test(
          'it should return the correct help string without descriptions',
          () {
            final command = RootCommand();

            command.arguments.addAll([
              StringArgument("string", false),
              IntegerArgument("int", false),
              DoubleArgument("double", false),
              BoolArgument("bool", false),
              FileArgument("file", true, false),
              DirectoryArgument("directory", false, true)
            ]);

            expect(
                getCommandHelpString(command),
                """
┌─────────────────────────────────────────────────────────┐
│                   Available arguments                   │
├───────────┬────────────────┬──────────┬─────────────────┤
│ Name      │ Type           │ Required │ Path must exist │
├───────────┼────────────────┼──────────┼─────────────────┤
│ string    │ string         │ false    │                 │
├───────────┼────────────────┼──────────┼─────────────────┤
│ int       │ integer        │ false    │                 │
├───────────┼────────────────┼──────────┼─────────────────┤
│ double    │ double         │ false    │                 │
├───────────┼────────────────┼──────────┼─────────────────┤
│ bool      │ boolean        │ false    │                 │
├───────────┼────────────────┼──────────┼─────────────────┤
│ file      │ file path      │ true     │ false           │
├───────────┼────────────────┼──────────┼─────────────────┤
│ directory │ directory path │ false    │ true            │
└───────────┴────────────────┴──────────┴─────────────────┘
"""
                    .trimLeft());
          },
        );

        test(
          'it should return the correct help string with descriptions',
          () {
            final command = RootCommand();

            command.arguments.addAll([
              StringArgument("string", false, description: "A string argument"),
              IntegerArgument("int", false, description: "An integer argument"),
              DoubleArgument("double", false, description: "A double argument"),
              BoolArgument("bool", false, description: "A boolean argument"),
              FileArgument(
                "file",
                true,
                false,
                description: "A file path argument",
              ),
              DirectoryArgument(
                "directory",
                false,
                true,
                description: "A directory path argument",
              )
            ]);

            expect(
                getCommandHelpString(command),
                """
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                                 Available arguments                                 │
├───────────┬────────────────┬──────────┬─────────────────┬───────────────────────────┤
│ Name      │ Type           │ Required │ Path must exist │ Description               │
├───────────┼────────────────┼──────────┼─────────────────┼───────────────────────────┤
│ string    │ string         │ false    │                 │ A string argument         │
├───────────┼────────────────┼──────────┼─────────────────┼───────────────────────────┤
│ int       │ integer        │ false    │                 │ An integer argument       │
├───────────┼────────────────┼──────────┼─────────────────┼───────────────────────────┤
│ double    │ double         │ false    │                 │ A double argument         │
├───────────┼────────────────┼──────────┼─────────────────┼───────────────────────────┤
│ bool      │ boolean        │ false    │                 │ A boolean argument        │
├───────────┼────────────────┼──────────┼─────────────────┼───────────────────────────┤
│ file      │ file path      │ true     │ false           │ A file path argument      │
├───────────┼────────────────┼──────────┼─────────────────┼───────────────────────────┤
│ directory │ directory path │ false    │ true            │ A directory path argument │
└───────────┴────────────────┴──────────┴─────────────────┴───────────────────────────┘
"""
                    .trimLeft());
          },
        );

        test(
          'it should throw an error when an unknown argument class was given',
          () {
            final command = RootCommand();
            command.arguments.add(UnknownArgument("unknown", false));

            expect(() {
              getCommandHelpString(command);
            }, throwsA(isA<UnknownArgumentError>()));
          },
        );
      });

      group('flags', () {
        test(
          'it should return the correct help string without descriptions',
          () {
            final command = RootCommand();

            command.flags.addAll([
              StringFlag("string", [], false),
              IntegerFlag("integer", [], false),
              DoubleFlag("double", [], false),
              BoolFlag("bool", [], false),
              FileFlag("file", [], false, true),
              DirectoryFlag("directory", [], true, false),
            ]);

            expect(
                getCommandHelpString(command),
                """
┌─────────────────────────────────────────────────────────┐
│                     Available flags                     │
├───────────┬────────────────┬──────────┬─────────────────┤
│ Name      │ Type           │ Required │ Path must exist │
├───────────┼────────────────┼──────────┼─────────────────┤
│ string    │ string         │ false    │                 │
├───────────┼────────────────┼──────────┼─────────────────┤
│ integer   │ integer        │ false    │                 │
├───────────┼────────────────┼──────────┼─────────────────┤
│ double    │ double         │ false    │                 │
├───────────┼────────────────┼──────────┼─────────────────┤
│ bool      │ boolean        │ false    │                 │
├───────────┼────────────────┼──────────┼─────────────────┤
│ file      │ file path      │ false    │ true            │
├───────────┼────────────────┼──────────┼─────────────────┤
│ directory │ directory path │ true     │ false           │
└───────────┴────────────────┴──────────┴─────────────────┘
"""
                    .trimLeft());
          },
        );

        test(
          'it should return the correct help string with descriptions',
          () {
            final command = RootCommand();

            command.flags.addAll([
              StringFlag("string", [], false, description: "A string flag"),
              IntegerFlag("integer", [], false, description: "An integer flag"),
              DoubleFlag("double", [], false, description: "A double flag"),
              BoolFlag("bool", [], false, description: "A bool flag"),
              FileFlag("file", [], false, true, description: "A file flag"),
              DirectoryFlag(
                "directory",
                [],
                false,
                true,
                description: "A directory flag",
              ),
            ]);

            expect(
                getCommandHelpString(command),
                """
┌────────────────────────────────────────────────────────────────────────────┐
│                              Available flags                               │
├───────────┬────────────────┬──────────┬─────────────────┬──────────────────┤
│ Name      │ Type           │ Required │ Path must exist │ Description      │
├───────────┼────────────────┼──────────┼─────────────────┼──────────────────┤
│ string    │ string         │ false    │                 │ A string flag    │
├───────────┼────────────────┼──────────┼─────────────────┼──────────────────┤
│ integer   │ integer        │ false    │                 │ An integer flag  │
├───────────┼────────────────┼──────────┼─────────────────┼──────────────────┤
│ double    │ double         │ false    │                 │ A double flag    │
├───────────┼────────────────┼──────────┼─────────────────┼──────────────────┤
│ bool      │ boolean        │ false    │                 │ A bool flag      │
├───────────┼────────────────┼──────────┼─────────────────┼──────────────────┤
│ file      │ file path      │ false    │ true            │ A file flag      │
├───────────┼────────────────┼──────────┼─────────────────┼──────────────────┤
│ directory │ directory path │ false    │ true            │ A directory flag │
└───────────┴────────────────┴──────────┴─────────────────┴──────────────────┘
"""
                    .trimLeft());
          },
        );

        test(
          'it should throw an error when an unknown argument class was given',
          () {
            final command = RootCommand();
            command.flags.add(UnknownFlag("unknown", [], false));

            expect(() {
              getCommandHelpString(command);
            }, throwsA(isA<UnknownFlagError>()));
          },
        );
      });
    });
  });
}
