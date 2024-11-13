import 'package:test/test.dart';
import 'package:ying_shared/utils/table/text_alignment.dart';

void main() {
  test(
    'it should return the input as is when it is longer than the given max width',
    () {
      var result = TextAlignment.left.alignString("test", 0);

      expect(result, "test");
    },
  );

  test(
    'it should return the input as is when it has the same length as the given max width',
    () {
      var result = TextAlignment.left.alignString("test", 4);

      expect(result, "test");
    },
  );

  test(
    'it should align the input properly according to the left alignment',
    () {
      var result = TextAlignment.left.alignString("test", 5);

      expect(result, "test ");
    },
  );

  group('center alignment', () {
    test('it should use the floored amount of space on the left side', () {
      var result = TextAlignment.center.alignString("test", 5);

      expect(result, "test ");
    });

    test(
      'it should correctly align in the center when enough space is available',
      () {
        var result = TextAlignment.center.alignString("test", 6);

        expect(result, " test ");
      },
    );
  });

  test(
    'it should align the input properly according to the right alignment',
    () {
      var result = TextAlignment.right.alignString("test", 5);

      expect(result, " test");
    },
  );
}
