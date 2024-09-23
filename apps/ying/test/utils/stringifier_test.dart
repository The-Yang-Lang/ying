import 'package:test/test.dart';
import 'package:ying/logging/ansi_color.dart';
import 'package:ying/logging/log_level.dart';
import 'package:ying/logging/logger.dart';
import 'package:ying/utils/stringifier.dart';

void main() {
  test('stringify should correctly stringify the value', () {
    var cases = [
      ("test", '"test"'),
      (42, "42"),
      (13.37, "13.37"),
      (true, "true"),
      (false, "false"),
      ([1, 2, 3], '[\n    1,\n    2,\n    3,\n]'),
      ({1, 2, 3}, '{\n    1,\n    2,\n    3,\n}'),
      ({"key": "value"}, '{\n    "key": "value",\n}'),
      (MapEntry("key", "value"), '"key": "value"'),
      ((1, 2), "(1, 2)"),
      (LogLevel.info, "LogLevel.info"),
      (AnsiColor.reset, "AnsiColor()"),
      (
        Logger.withSimpleName("test", LogLevel.info),
        "Logger(\n    currentLevel: LogLevel.info,\n    nameParts: [\n        \"test\",\n    ]\n)"
      )
    ];

    for (var (input, expected) in cases) {
      expect(
        Stringifier.stringify(input),
        expected,
      );
    }
  });
}