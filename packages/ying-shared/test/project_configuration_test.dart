import 'dart:convert';

import 'package:test/test.dart';
import 'package:ying_shared/project_configuration.dart';

void main() {
  group('ProjectConfiguration', () {
    test('it should return a valid instance', () {
      final name = "test";
      final version = "0.0.0";
      final license = "MIT";
      final scripts = <String, String>{};
      final dependencies = <String, String>{};
      final developmentDependencies = <String, String>{};

      final result = ProjectConfiguration(
        name,
        version,
        license,
        scripts,
        dependencies,
        developmentDependencies,
      );

      expect(result, isA<ProjectConfiguration>());
    });

    group('ProjectConfiguration.init/3', () {
      test('it should set some default scripts', () {
        final result = ProjectConfiguration.init("test", "0.0.0", "MIT");

        expect(result.scripts, {
          "test": "ying test",
        });
      });

      test('it should set the dependencies to a empty map', () {
        final result = ProjectConfiguration.init("test", "0.0.0", "MIT");

        expect(result.dependencies, {});
      });

      test('it should set the developmentDependencies to a empty map', () {
        final result = ProjectConfiguration.init("test", "0.0.0", "MIT");

        expect(result.developmentDependencies, {});
      });
    });

    group('validate/0', () {
      test(
        'it should return true when the ProjectConfiguration with a short package name is valid',
        () {
          final input = ProjectConfiguration.init("test", "0.0.0", "MIT");
          final result = input.validate();

          expect(result, isTrue);
        },
      );

      test(
        'it should return true when the ProjectConfiguration with a long package name is valid',
        () {
          final input =
              ProjectConfiguration.init("@me/package", "0.0.0", "MIT");
          final result = input.validate();

          expect(result, isTrue);
        },
      );

      test('it should return false when the package name is invalid', () {
        final input = ProjectConfiguration.init("1234", "0.0.0", "MIT");
        final result = input.validate();

        expect(result, isFalse);
      });

      test('it should return false when the package version is invalid', () {
        final input = ProjectConfiguration.init("test", "asdf", "MIT");
        final result = input.validate();

        expect(result, isFalse);
      });

      test('it should return false when the license is invalid', () {
        final input = ProjectConfiguration.init("test", "0.0.0", "asdf");
        final result = input.validate();

        expect(result, isFalse);
      });
    });

    group('toJson/0', () {
      test('it should return a map with the name, version and license', () {
        final projectConfiguration = ProjectConfiguration(
          "test",
          "0.0.0",
          "MIT",
          {},
          {},
          {},
        );

        final result = projectConfiguration.toJson();
        expect(result, {"name": "test", "version": "0.0.0", "license": "MIT"});
      });

      test('it should include the scripts when they are not empty', () {
        final projectConfiguration = ProjectConfiguration(
          "test",
          "0.0.0",
          "MIT",
          {
            "test": "ying test",
          },
          {},
          {},
        );

        final result = projectConfiguration.toJson();

        expect(result, {
          "name": "test",
          "version": "0.0.0",
          "license": "MIT",
          "scripts": {
            "test": "ying test",
          },
        });
      });

      test('it should include the dependencies when they are not empty', () {
        final projectConfiguration = ProjectConfiguration(
          "test",
          "0.0.0",
          "MIT",
          {},
          {"example-package": "0.0.0"},
          {},
        );

        final result = projectConfiguration.toJson();

        expect(result, {
          "name": "test",
          "version": "0.0.0",
          "license": "MIT",
          "dependencies": {
            "example-package": "0.0.0",
          },
        });
      });

      test(
        'it should include the development dependencies when they are not empty',
        () {
          final projectConfiguration = ProjectConfiguration(
            "test",
            "0.0.0",
            "MIT",
            {},
            {},
            {"example-package": "0.0.0"},
          );

          final result = projectConfiguration.toJson();

          expect(result, {
            "name": "test",
            "version": "0.0.0",
            "license": "MIT",
            "developmentDependencies": {
              "example-package": "0.0.0",
            },
          });
        },
      );
    });

    group('fromJson/1', () {
      test('it should throw an error when the input is not a map', () {
        expect(() {
          ProjectConfiguration.fromJson(123);
        }, throwsA(isA<JsonUnsupportedObjectError>()));

        expect(() {
          ProjectConfiguration.fromJson(123.123);
        }, throwsA(isA<JsonUnsupportedObjectError>()));

        expect(() {
          ProjectConfiguration.fromJson("unit test");
        }, throwsA(isA<JsonUnsupportedObjectError>()));

        expect(() {
          ProjectConfiguration.fromJson(true);
        }, throwsA(isA<JsonUnsupportedObjectError>()));

        expect(() {
          ProjectConfiguration.fromJson(false);
        }, throwsA(isA<JsonUnsupportedObjectError>()));

        expect(() {
          ProjectConfiguration.fromJson([]);
        }, throwsA(isA<JsonUnsupportedObjectError>()));
      });

      test(
        'it should correctly decode a fully defined ProjectConfiguration',
        () {
          final input = {
            "name": "test",
            "version": "0.0.0",
            "license": "MIT",
            "scripts": {
              "test": "ying test",
            },
            "dependencies": {
              "example-package": "0.0.0",
            },
            "developmentDependencies": {
              "example-package": "0.0.0",
            }
          };

          final result = ProjectConfiguration.fromJson(input);

          expect(result.name, "test");
          expect(result.version, "0.0.0");
          expect(result.license, "MIT");

          expect(result.scripts, {
            "test": "ying test",
          });

          expect(result.dependencies, {
            "example-package": "0.0.0",
          });

          expect(result.developmentDependencies, {
            "example-package": "0.0.0",
          });
        },
      );

      test(
        'it should decode the ProjectConfiguration when the scripts, dependencies and developmentDependencies are missing',
        () {
          final input = {
            "name": "test",
            "version": "0.0.0",
            "license": "MIT",
          };

          final result = ProjectConfiguration.fromJson(input);

          expect(result.name, "test");
          expect(result.version, "0.0.0");
          expect(result.license, "MIT");
          expect(result.scripts, {});
          expect(result.dependencies, {});
          expect(result.developmentDependencies, {});
        },
      );

      test(
        'it should throw an JsonUnsupportedObjectError when the name is not a string',
        () {
          final input = {
            "name": 123,
          };

          expect(() {
            ProjectConfiguration.fromJson(input);
          }, throwsA(isA<JsonUnsupportedObjectError>()));
        },
      );

      test(
        'it should throw an JsonUnsupportedObjectError when the version is not a string',
        () {
          final input = {
            "name": "test",
            "version": 123,
          };

          expect(() {
            ProjectConfiguration.fromJson(input);
          }, throwsA(isA<JsonUnsupportedObjectError>()));
        },
      );

      test(
        'it should throw an JsonUnsupportedObjectError when the version is not a string',
        () {
          final input = {
            "name": "test",
            "version": "0.0.0",
            "license": 123,
          };

          expect(() {
            ProjectConfiguration.fromJson(input);
          }, throwsA(isA<JsonUnsupportedObjectError>()));
        },
      );

      test(
        'it should throw an JsonUnsupportedObjectError when the scripts are not a Map<String, String>',
        () {
          final input = {
            "name": "test",
            "version": "0.0.0",
            "license": "MIT",
            "scripts": 123,
          };

          expect(() {
            ProjectConfiguration.fromJson(input);
          }, throwsA(isA<JsonUnsupportedObjectError>()));
        },
      );

      test(
        'it should throw an JsonUnsupportedObjectError when the dependencies are not a Map<String, String>',
        () {
          final input = {
            "name": "test",
            "version": "0.0.0",
            "license": "MIT",
            "dependencies": 123,
          };

          expect(() {
            ProjectConfiguration.fromJson(input);
          }, throwsA(isA<JsonUnsupportedObjectError>()));
        },
      );

      test(
        'it should throw an JsonUnsupportedObjectError when the developmentDependencies are not a Map<String, String>',
        () {
          final input = {
            "name": "test",
            "version": "0.0.0",
            "license": "MIT",
            "developmentDependencies": 123,
          };

          expect(() {
            ProjectConfiguration.fromJson(input);
          }, throwsA(isA<JsonUnsupportedObjectError>()));
        },
      );
    });
  });
}
