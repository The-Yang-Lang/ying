import 'package:test/test.dart';
import 'package:ying_shared/logging/ansi_color.dart';
import 'package:ying_shared/logging/log_level.dart';
import 'package:ying_shared/logging/logger.dart';
import 'package:ying_shared/utils/stringify.dart';

void main() {
  test('stringify should correctly stringify the value', () {
    final cases = [
      (null, "null"),
      ("test", '"test"'),
      (42, "42"),
      (13.37, "13.37"),
      (true, "true"),
      (false, "false"),
      ([], "[]"),
      ([1, 2, 3], '[\n    1,\n    2,\n    3,\n]'),
      ({1, 2, 3}, '{\n    1,\n    2,\n    3,\n}'),
      ({"key": "value"}, '{\n    "key": "value",\n}'),
      (MapEntry("key", "value"), '"key": "value"'),
      ((1, 2), "(1, 2)"),
      (LogLevel.info, "LogLevel.info"),
      (AnsiColor.reset, "\x1B[0m"),
      (
        Logger.withSimpleName("test", LogLevel.info),
        "Logger(\n    currentLevel: LogLevel.info,\n    nameParts: [\n        \"test\",\n    ]\n)"
      )
    ];

    for (final (input, expected) in cases) {
      expect(
        stringify(input),
        expected,
      );
    }
  });

  test(
    'stringifyInstance should return the class name when an empty map of fields are provided',
    () {
      expect(stringifyInstance("Logger", {}), "Logger()");
    },
  );
}
