import 'package:ying_shared/text_location.dart';
import 'package:ying_shared/utils/stringify.dart';

class TextSpan {
  /// The starting location of the span
  final TextLocation start;

  /// The ending location of the span
  final TextLocation end;

  TextSpan(this.start, this.end);

  /// Creates a clone of this span
  TextSpan clone() {
    return TextSpan(
      start.clone(),
      end.clone(),
    );
  }

  @override
  String toString() {
    return stringifyInstance("TextSpan", fields: {
      "start": start,
      "end": end,
    });
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextSpan &&
          runtimeType == other.runtimeType &&
          start == other.start &&
          end == other.end;

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}
