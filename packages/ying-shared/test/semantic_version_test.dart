import 'package:test/test.dart';
import 'package:ying_shared/semantic_version.dart';

void main() {
  group('parseSemanticVersion', () {
    test('it should parse a SemVer with major, minor and patch', () {
      final result = parseSemanticVersion("0.0.0");

      expect(result?.major, 0);
      expect(result?.minor, 0);
      expect(result?.patch, 0);
      expect(result?.preRelease, null);
      expect(result?.build, null);
    });

    test(
      'it should parse a SemVer with major, minor, patch and pre-release identifier',
      () {
        final result = parseSemanticVersion("0.0.0-snapshot");

        expect(result?.major, 0);
        expect(result?.minor, 0);
        expect(result?.patch, 0);
        expect(result?.preRelease, ["snapshot"]);
        expect(result?.build, null);
      },
    );

    test(
      'it should parse a SemVer with major, minor, patch and build identifier',
      () {
        final result = parseSemanticVersion("0.0.0+1");

        expect(result?.major, 0);
        expect(result?.minor, 0);
        expect(result?.patch, 0);
        expect(result?.preRelease, null);
        expect(result?.build, ["1"]);
      },
    );

    test(
      'it should parse a SemVer with major, minor, patch, build and pre-release identifier',
      () {
        final result = parseSemanticVersion("0.0.0-snapshot+1");

        expect(result?.major, 0);
        expect(result?.minor, 0);
        expect(result?.patch, 0);
        expect(result?.preRelease, ["snapshot"]);
        expect(result?.build, ["1"]);
      },
    );

    test(
      'it should return null when only the major version was given',
      () {
        final result = parseSemanticVersion("0");

        expect(result, isNull);
      },
    );

    test(
      'it should return null when only the major and minor version was given',
      () {
        final result = parseSemanticVersion("0.0");

        expect(result, isNull);
      },
    );

    test('it should return null when the major version is negative', () {
      final result = parseSemanticVersion("-1.0.0");

      expect(result, isNull);
    });

    test('it should return null when the minor version is negative', () {
      final result = parseSemanticVersion("1.-1.0");

      expect(result, isNull);
    });

    test('it should return null when the patch version is negative', () {
      final result = parseSemanticVersion("1.1.-1");

      expect(result, isNull);
    });
  });

  group('SemanticVersion', () {
    group('toString', () {
      test(
        'it should return the correct string for major, minor and patch',
        () {
          final result = SemanticVersion(
            major: 0,
            minor: 0,
            patch: 0,
          ).toString();

          expect(result, "0.0.0");
        },
      );

      test(
        'it should return the correct string for major, minor, patch and pre-release',
        () {
          final result = SemanticVersion(
            major: 0,
            minor: 0,
            patch: 0,
            preRelease: ["snapshot"],
          ).toString();

          expect(result, "0.0.0-snapshot");
        },
      );

      test(
        'it should return the correct string for major, minor, patch, pre-release and build',
        () {
          final result = SemanticVersion(
            major: 0,
            minor: 0,
            patch: 0,
            preRelease: ["snapshot"],
            build: ["1"],
          ).toString();

          expect(result, "0.0.0-snapshot+1");
        },
      );

      test('it should return the correct string for major, minor and build',
          () {
        final result = SemanticVersion(
          major: 0,
          minor: 0,
          patch: 0,
          build: ["1"],
        ).toString();

        expect(result, "0.0.0+1");
      });
    });
  });
}
