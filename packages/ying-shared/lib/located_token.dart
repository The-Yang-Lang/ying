import 'package:ying_shared/text_span.dart';
import 'package:ying_shared/token.dart';
import 'package:ying_shared/utils/stringify.dart';

class LocatedToken {
  final Token token;

  final TextSpan span;

  LocatedToken(this.token, this.span);

  @override
  String toString() {
    return stringifyInstance("LocatedToken", fields: {
      "token": token,
      "span": span,
    });
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocatedToken &&
          runtimeType == other.runtimeType &&
          token == other.token &&
          span == other.span;

  @override
  int get hashCode => token.hashCode ^ span.hashCode;
}
