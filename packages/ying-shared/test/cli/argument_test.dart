import 'dart:io';

import 'package:test/test.dart';
import 'package:ying_shared/cli/argument.dart';
import 'package:ying_shared/cli/errors.dart';

void main() {
  group('Boolean argument', () {
    test('it should parse the value "true"', () {
      final argument = BoolArgument("", false);

      expect(argument.parse("true"), true);
    });

    test('it should parse the value "false"', () {
      final argument = BoolArgument("", false);

      expect(argument.parse("false"), false);
    });

    test(
      'it should throw an error when the given value is not a parsable boolean',
      () {
        expect(() {
          final argument = BoolArgument("", false);

          argument.parse("unit-test");
        }, throwsA(isA<InvalidBooleanArgumentError>()));
      },
    );
  });

  group('String argument', () {
    test('it should parse the value as is', () {
      final argument = StringArgument("", false);

      expect(argument.parse("unit-test"), "unit-test");
    });
  });

  group('Integer argument', () {
    test('it should parse a valid integer representation', () {
      final argument = IntegerArgument("", false);

      expect(argument.parse("42"), 42);
    });

    test(
      'it should throw an error when the given value is not an integer',
      () {
        expect(() {
          final argument = IntegerArgument("", false);

          argument.parse("unit-test");
        }, throwsA(isA<InvalidIntegerArgumentError>()));
      },
    );
  });

  group('Double argument', () {
    test('it should parse a valid double representation', () {
      final argument = DoubleArgument("", false);

      expect(argument.parse("13.37"), 13.37);
    });

    test(
      'it should throw an error when the given value is not a double',
      () {
        expect(() {
          final argument = DoubleArgument("", false);

          argument.parse("unit-test");
        }, throwsA(isA<InvalidDoubleArgumentError>()));
      },
    );
  });

  group('File argument', () {
    test('it should parse the value as a File', () {
      final argument = FileArgument("", false, false);

      expect(argument.parse("./pubspec.yaml"), isA<File>());
    });

    test('it should parse the value as a File and validate its existence', () {
      final argument = FileArgument("", false, true);

      expect(argument.parse("./pubspec.yaml"), isA<File>());
    });

    test(
      'it should throw an error when the file does not exists but its existence is required',
      () {
        expect(() {
          final argument = FileArgument("", false, true);

          argument.parse("not-existing-file.txt");
        }, throwsA(isA<InvalidFilePathArgumentError>()));
      },
    );
  });
  group('Directory argument', () {
    test('it should parse the value as a Directory', () {
      final argument = DirectoryArgument("", false, false);

      expect(argument.parse("./lib/"), isA<Directory>());
    });

    test(
      'it should parse the value as a Directory and validate its existence',
      () {
        final argument = DirectoryArgument("", false, true);

        expect(argument.parse("./lib/"), isA<Directory>());
      },
    );

    test(
      'it should throw an error when the Directory does not exists but its existence is required',
      () {
        expect(() {
          final argument = DirectoryArgument("", false, true);

          argument.parse("./not-existing-directory/");
        }, throwsA(isA<InvalidDirectoryPathArgumentError>()));
      },
    );
  });
}
