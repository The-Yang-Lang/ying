import 'package:test/test.dart';
import 'package:ying/cli/command.dart';
import 'package:ying/cli/command_execution_context.dart';

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
  Future<void> execute(CommandExecutionContext _) async {}
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
  Future<void> execute(CommandExecutionContext _) async {}
}

void main() {
  group('Command', () {
    group('findCommandRecursivly', () {
      test('it should return null when no commands were given', () {
        expect(findCommandRecursivly([], []), null);
      });

      test('it should return null when no arguments were given', () {
        expect(findCommandRecursivly([RootCommand()], []), null);
      });

      test(
        'it should return null when no command matches the first argument',
        () {
          expect(findCommandRecursivly([RootCommand()], ["unit"]), null);
        },
      );

      test(
        'it should return the found top-level command when the first argument matches its name',
        () {
          var result = findCommandRecursivly([RootCommand()], ["root"]);

          expect(result != null, true);

          var (foundCommand, commandArguments) = result!;

          expect(foundCommand.name, "root");
          expect(commandArguments, []);
        },
      );

      test(
        'it should return the found top-level command including the trailing arguments when the first argument matches its name',
        () {
          var result = findCommandRecursivly(
            [RootCommand()],
            ["root", "unit", "test"],
          );

          expect(result != null, true);

          var (foundCommand, commandArguments) = result!;

          expect(foundCommand.name, "root");
          expect(commandArguments, ["unit", "test"]);
        },
      );

      test('it should return the found subcommand', () {
        var result = findCommandRecursivly(
          [RootCommand()],
          ["root", "sub"],
        );

        expect(result != null, true);

        var (foundCommand, commandArguments) = result!;

        expect(
          foundCommand.name,
          "sub",
        );

        expect(commandArguments, []);
      });

      test(
          'it should return the found subcommand including the trailing arguments',
          () {
        var result = findCommandRecursivly(
          [RootCommand()],
          ["root", "sub", "unit", "test"],
        );

        expect(result != null, true);

        var (foundCommand, commandArguments) = result!;

        expect(foundCommand.name, "sub");
        expect(commandArguments, ["unit", "test"]);
      });
    });
  });
}
