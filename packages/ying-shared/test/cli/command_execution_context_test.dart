import 'dart:io';

import 'package:test/test.dart';
import 'package:ying_shared/cli/argument.dart';
import 'package:ying_shared/cli/command.dart';
import 'package:ying_shared/cli/command_execution_context.dart';
import 'package:ying_shared/cli/errors.dart';
import 'package:ying_shared/cli/flag.dart';

class TestCommand extends Command {
  TestCommand() : super("", [], [], []);

  @override
  void execute(CommandExecutionContext _) {}
}

void main() {
  group('createCommandExecutionContext', () {
    group('parsing flags', () {
      test('it should parse a flag with its full name', () {
        final command = TestCommand();
        command.flags = [BoolFlag("force", [], false)];

        final result = createCommandExecutionContext(command, ["--force=true"]);

        expect(result.parsedFlags["force"], true);
      });

      test('it should parse a flag with its alias', () {
        final command = TestCommand();
        command.flags = [
          BoolFlag("force", ["f"], false)
        ];

        final result = createCommandExecutionContext(command, ["-f=true"]);

        expect(result.parsedFlags["force"], true);
      });

      test('it should skip extranous arguments', () {
        final command = TestCommand();

        final result = createCommandExecutionContext(command, ["unit-test"]);

        expect(result.parsedArguments, {});
        expect(result.parsedFlags, {});
      });

      test('it should skip flags which are not registered', () {
        final command = TestCommand();
        command.flags = [
          BoolFlag("force", ["f"], false)
        ];

        final result = createCommandExecutionContext(command, ["-test=true"]);

        expect(result.parsedFlags["force"], false);
      });

      test(
        'it should throw an error when there are unparsed required flags',
        () {
          final command = TestCommand();
          command.flags = [StringFlag("test", [], true)];

          expect(() {
            createCommandExecutionContext(command, []);
          }, throwsA(isA<UnparsedRequiredFlagsError>()));
        },
      );

      test(
        'it should assign "false" as default value for not provided required boolean flags',
        () {
          final command = TestCommand();
          command.flags = [BoolFlag("test", [], true)];

          final commandExecutionContext = createCommandExecutionContext(
            command,
            [],
          );

          expect(commandExecutionContext.parsedFlags["test"], false);
        },
      );

      test(
        'it should assign "false" as default value for not provided optional boolean flags',
        () {
          final command = TestCommand();
          command.flags = [BoolFlag("test", [], false)];

          final commandExecutionContext = createCommandExecutionContext(
            command,
            [],
          );

          expect(commandExecutionContext.parsedFlags["test"], false);
        },
      );

      group('throwing errors', () {
        test(
          'it should throw an error when a string flag got no value',
          () {
            final command = TestCommand();
            command.flags = [StringFlag("test", [], true)];

            expect(() {
              createCommandExecutionContext(command, ["--test"]);
            }, throwsA(isA<InvalidStringFlagError>()));
          },
        );

        test(
          'it should throw an error when an integer flag got no value',
          () {
            final command = TestCommand();
            command.flags = [IntegerFlag("test", [], true)];

            expect(() {
              createCommandExecutionContext(command, ["--test"]);
            }, throwsA(isA<InvalidIntegerFlagError>()));
          },
        );

        test(
          'it should throw an error when a double flag got no value',
          () {
            final command = TestCommand();
            command.flags = [DoubleFlag("test", [], true)];

            expect(() {
              createCommandExecutionContext(command, ["--test"]);
            }, throwsA(isA<InvalidDoubleFlagError>()));
          },
        );

        test(
          'it should throw an error when a file flag got no value',
          () {
            final command = TestCommand();
            command.flags = [FileFlag("test", [], false, true)];

            expect(() {
              createCommandExecutionContext(command, ["--test"]);
            }, throwsA(isA<InvalidFilePathFlagError>()));
          },
        );

        test(
          'it should throw an error when a directory flag got no value',
          () {
            final command = TestCommand();
            command.flags = [DirectoryFlag("test", [], false, true)];

            expect(() {
              createCommandExecutionContext(command, ["--test"]);
            }, throwsA(isA<InvalidDirectoryPathFlagError>()));
          },
        );
      });
    });

    group('parsing arguments', () {
      test('it should parse a single argument', () {
        final command = TestCommand();
        command.arguments = [DirectoryArgument("directory", false, false)];

        final result = createCommandExecutionContext(command, ["./"]);

        expect(result.parsedArguments["directory"], isA<Directory>());
      });

      test('it should parse two arguments', () {
        final command = TestCommand();
        command.arguments = [
          DirectoryArgument("directory", false, false),
          FileArgument("config", false, false),
        ];

        final result = createCommandExecutionContext(command, [
          "./",
          "config.json",
        ]);

        expect(result.parsedArguments["directory"], isA<Directory>());
        expect(result.parsedArguments["config"], isA<File>());
      });

      test(
        'it should throw an error when there are unparsed required arguments',
        () {
          final command = TestCommand();
          command.arguments = [StringArgument("test", true)];

          expect(() {
            createCommandExecutionContext(command, []);
          }, throwsA(isA<UnparsedRequiredArgumentsError>()));
        },
      );
    });

    group('parsing arguments and flags', () {
      test('it should parse one argument and one flag', () {
        final command = TestCommand();
        command.arguments = [FileArgument("config", false, false)];
        command.flags = [BoolFlag("force", [], false)];

        final result = createCommandExecutionContext(command, [
          "--force=false",
          "./",
        ]);

        expect(result.parsedArguments["config"], isA<File>());
        expect(result.parsedFlags["force"], false);
      });

      test('it should parse one argument and in between two flags', () {
        final command = TestCommand();
        command.arguments = [FileArgument("config", false, false)];
        command.flags = [
          BoolFlag("force", [], false),
          BoolFlag("version", [], false)
        ];

        final result = createCommandExecutionContext(
            command, ["--force=false", "./", "--version"]);

        expect(result.parsedArguments["config"], isA<File>());
        expect(result.parsedFlags["force"], false);
        expect(result.parsedFlags["version"], true);
      });
    });
  });

  group('CommandExecutionContext', () {
    test('toString should return the correct string', () {
      final commandExecutionContext = CommandExecutionContext({}, {});

      expect(commandExecutionContext.toString(), """CommandExecutionContext(
    parsedArguments: {},
    parsedFlags: {}
)""");
    });
  });
}
