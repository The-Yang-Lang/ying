import 'package:test/test.dart';
import 'package:ying/logging/log_level.dart';

void main() {
  test(
      'getLogLevelFromEnvironment returns the info level when the environment variable is not set',
      () {
    var result = getLogLevelFromEnvironment({});

    expect(result, LogLevel.info);
  });

  test(
      'getLogLevelFromEnvironment should return the info level when no LogLevel was matched',
      () {
    var result = getLogLevelFromEnvironment(
      {"LOG_LEVEL": "gibberish"},
    );

    expect(result, LogLevel.info);
  });

  test('getLogLevelFromEnvironment returns the correctly matched LogLevel', () {
    var cases = [
      // uppercased values
      ("ERROR", LogLevel.error),
      ("WARN", LogLevel.warn),
      ("INFO", LogLevel.info),
      ("DEBUG", LogLevel.debug),
      ("TRACE", LogLevel.trace),

      // Lowercased values
      ("error", LogLevel.error),
      ("warn", LogLevel.warn),
      ("info", LogLevel.info),
      ("debug", LogLevel.debug),
      ("trace", LogLevel.trace),
    ];

    for (var (environmentVariableValue, expectedLogLevel) in cases) {
      var result = getLogLevelFromEnvironment(
        {"LOG_LEVEL": environmentVariableValue},
      );

      expect(result, expectedLogLevel);
    }
  });
}
