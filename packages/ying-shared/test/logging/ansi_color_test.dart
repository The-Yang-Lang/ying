import 'package:test/test.dart';
import 'package:ying_shared/logging/ansi_color.dart';

void main() {
  test('AnsiColor.reset should have a value of 0', () {
    expect(AnsiColor.reset.value, 0);
  });

  test('AnsiColor.red should have a value of 0', () {
    expect(AnsiColor.red.value, 31);
  });

  test('AnsiColor.yellow should have a value of 0', () {
    expect(AnsiColor.yellow.value, 33);
  });

  test('AnsiColor.magenta should have a value of 0', () {
    expect(AnsiColor.magenta.value, 35);
  });

  test('AnsiColor.cyan should have a value of 0', () {
    expect(AnsiColor.cyan.value, 36);
  });

  test('AnsiColor should return the correct escape sequence', () {
    final cases = [
      (AnsiColor.reset, "\u001b[0m"),
      (AnsiColor.red, "\u001b[31m"),
      (AnsiColor.yellow, "\u001b[33m"),
      (AnsiColor.magenta, "\u001b[35m"),
      (AnsiColor.cyan, "\u001b[36m"),
    ];

    for (final testCase in cases) {
      expect(testCase.$1.toString(), testCase.$2);
    }
  });
}
