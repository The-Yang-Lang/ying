import 'package:test/test.dart';
import 'package:ying_shared/logging/log_level.dart';

void main() {
  test(
    'the levelPadding should determine correctly the longest entry of the log levels',
    () {
      expect(levelPadding, 5);
    },
  );

  group('getLogLevelFromEnvironment', () {
    test('returns the info level when the environment variable is not set', () {
      final result = getLogLevelFromEnvironment(null);

      expect(result, LogLevel.info);
    });

    test('return the info level when no LogLevel was matched', () {
      final result = getLogLevelFromEnvironment(
        {"LOG_LEVEL": "gibberish"},
      );

      expect(result, LogLevel.info);
    });

    test('return the correctly matched LogLevel', () {
      final cases = [
        // uppercased values
        ("NONE", LogLevel.none),
        ("ERROR", LogLevel.error),
        ("WARN", LogLevel.warn),
        ("INFO", LogLevel.info),
        ("DEBUG", LogLevel.debug),
        ("TRACE", LogLevel.trace),

        // Lowercased values
        ("none", LogLevel.none),
        ("error", LogLevel.error),
        ("warn", LogLevel.warn),
        ("info", LogLevel.info),
        ("debug", LogLevel.debug),
        ("trace", LogLevel.trace),
      ];

      for (final (environmentVariableValue, expectedLogLevel) in cases) {
        final result = getLogLevelFromEnvironment(
          {"LOG_LEVEL": environmentVariableValue},
        );

        expect(result, expectedLogLevel);
      }
    });
  });
}
