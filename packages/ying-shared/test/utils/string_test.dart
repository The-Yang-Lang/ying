import 'package:test/test.dart';
import 'package:ying_shared/utils/string.dart';

void main() {
  group('wrapText', () {
    test('it should return an empty list when the line to break is empty', () {
      var result = wrapText("", 0);

      expect(result, []);
    });

    test(
      'it should return a list with one element when the line to break is shorter or equal to the max width',
      () {
        var result = wrapText("Hello", 5);

        expect(result, ["Hello"]);
      },
    );

    test(
      'it should return a list with multiple elements when the length of the line exceeds the given max width',
      () {
        var result = wrapText("Hello World", 5);

        expect(result, ["Hello", "World"]);
      },
    );

    test('it should break words which exceed the max width', () {
      var result = wrapText("Hello, World", 5);

      expect(result, ["Hello", ", Wor", "ld"]);
    });
  });
}
