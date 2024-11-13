import 'dart:io';

import 'package:test/test.dart';
import 'package:ying_shared/cli/errors.dart';
import 'package:ying_shared/cli/flag.dart';

void main() {
  group('Boolean flag', () {
    test('it should parse the value "true"', () {
      final flag = BoolFlag("", [], false);

      expect(flag.parse("true"), true);
    });

    test('it should parse the value "false"', () {
      final flag = BoolFlag("", [], false);

      expect(flag.parse("false"), false);
    });

    test(
      'it should throw an error when the given value is not a parsable boolean',
      () {
        expect(() {
          final flag = BoolFlag("", [], false);

          flag.parse("unit-test");
        }, throwsA(isA<InvalidBooleanFlagError>()));
      },
    );
  });

  group('String flag', () {
    test('it should parse the value as is', () {
      final flag = StringFlag("", [], false);

      expect(flag.parse("unit-test"), "unit-test");
    });
  });

  group('Integer flag', () {
    test('it should parse a valid integer representation', () {
      final flag = IntegerFlag("", [], false);

      expect(flag.parse("42"), 42);
    });

    test(
      'it should throw an error when the given value is not an integer',
      () {
        expect(() {
          final flag = IntegerFlag("", [], false);

          flag.parse("unit-test");
        }, throwsA(isA<InvalidIntegerFlagError>()));
      },
    );
  });

  group('Double flag', () {
    test('it should parse a valid double representation', () {
      final flag = DoubleFlag("", [], false);

      expect(flag.parse("13.37"), 13.37);
    });

    test(
      'it should throw an error when the given value is not a double',
      () {
        expect(() {
          final flag = DoubleFlag("", [], false);

          flag.parse("unit-test");
        }, throwsA(isA<InvalidDoubleFlagError>()));
      },
    );
  });

  group('File flag', () {
    test('it should parse the value as a File', () {
      final flag = FileFlag("", [], false, false);

      expect(flag.parse("./pubspec.yaml"), isA<File>());
    });

    test('it should parse the value as a File and validate its existence', () {
      final flag = FileFlag("", [], false, true);

      expect(flag.parse("./pubspec.yaml"), isA<File>());
    });

    test(
      'it should throw an error when the file does not exists but its existence is required',
      () {
        expect(() {
          final flag = FileFlag("", [], false, true);

          flag.parse("not-existing-file.txt");
        }, throwsA(isA<InvalidFilePathFlagError>()));
      },
    );
  });
  group('Directory flag', () {
    test('it should parse the value as a Directory', () {
      final flag = DirectoryFlag("", [], false, false);

      expect(flag.parse("./lib/"), isA<Directory>());
    });

    test(
      'it should parse the value as a Directory and validate its existence',
      () {
        final flag = DirectoryFlag("", [], false, true);

        expect(flag.parse("./lib/"), isA<Directory>());
      },
    );

    test(
      'it should throw an error when the Directory does not exists but its existence is required',
      () {
        expect(() {
          final flag = DirectoryFlag("", [], false, true);

          flag.parse("./not-existing-directory/");
        }, throwsA(isA<InvalidDirectoryPathFlagError>()));
      },
    );
  });
}
