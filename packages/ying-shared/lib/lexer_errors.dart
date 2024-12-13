import 'package:ying_shared/literal_type.dart';
import 'package:ying_shared/text_location.dart';

class UnterminatedLiteralException {
  LiteralType literalType;
  TextLocation startLocation;

  UnterminatedLiteralException(this.literalType, this.startLocation);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnterminatedLiteralException &&
          runtimeType == other.runtimeType &&
          literalType == other.literalType &&
          startLocation == other.startLocation;

  @override
  int get hashCode => Object.hash(literalType, startLocation);
}

class UnterminatedMultiLineComment {
  TextLocation startLocation;

  UnterminatedMultiLineComment(this.startLocation);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnterminatedMultiLineComment &&
          runtimeType == other.runtimeType &&
          startLocation == other.startLocation;

  @override
  int get hashCode => startLocation.hashCode;
}
