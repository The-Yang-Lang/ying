import 'package:ying_shared/utils/stringify.dart';

/// The base class for all tokens
abstract class Token {
  bool isMatchingToken(Token? other);

  @override
  String toString() {
    return stringifyInstance("Token");
  }
}

class IdentifierToken extends Token {
  final String value;

  IdentifierToken(this.value);

  @override
  String toString() {
    return stringifyInstance("IdentifierToken", fields: {
      "value": value,
    });
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IdentifierToken &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  bool isMatchingToken(Token? other) => other is IdentifierToken;
}

class KeywordToken extends Token {
  final String value;

  KeywordToken(this.value);

  @override
  String toString() {
    return stringifyInstance("KeywordToken", fields: {
      "value": value,
    });
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KeywordToken &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  bool isMatchingToken(Token? other) =>
      other is KeywordToken && value == other.value;
}

class SpecialCharacterToken extends Token {
  final String value;

  SpecialCharacterToken(this.value);

  @override
  String toString() {
    return stringifyInstance("SpecialCharacterToken", fields: {
      "value": value,
    });
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpecialCharacterToken &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  bool isMatchingToken(Token? other) =>
      other is SpecialCharacterToken && value == other.value;
}

class StringToken extends Token {
  final String value;
  final String rawValue;

  StringToken(this.value, this.rawValue);

  @override
  String toString() {
    return stringifyInstance("StringToken", fields: {
      "value": value,
      "rawValue": rawValue,
    });
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StringToken &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          rawValue == other.rawValue;

  @override
  int get hashCode => value.hashCode ^ rawValue.hashCode;

  @override
  bool isMatchingToken(Token? other) => other is StringToken;
}

class CharacterToken extends Token {
  final String value;
  final String rawValue;

  CharacterToken(this.value, this.rawValue);

  @override
  String toString() {
    return stringifyInstance("CharacterToken", fields: {
      "value": value,
      "rawValue": rawValue,
    });
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterToken &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          rawValue == other.rawValue;

  @override
  int get hashCode => value.hashCode ^ rawValue.hashCode;

  @override
  bool isMatchingToken(Token? other) => other is CharacterToken;
}

class InterpolatableStringToken extends Token {
  final String value;
  final String rawValue;

  InterpolatableStringToken(this.value, this.rawValue);

  @override
  String toString() {
    return stringifyInstance("InterpolatableStringToken", fields: {
      "value": value,
      "rawValue": rawValue,
    });
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InterpolatableStringToken &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          rawValue == other.rawValue;

  @override
  int get hashCode => value.hashCode ^ rawValue.hashCode;

  @override
  bool isMatchingToken(Token? other) => other is InterpolatableStringToken;
}

class NumberToken extends Token {
  final num value;
  final int radix;

  NumberToken(this.value, this.radix);

  NumberToken.binary(this.value) : radix = 2;

  NumberToken.octal(this.value) : radix = 8;

  NumberToken.decimal(this.value) : radix = 10;

  NumberToken.hexadecimal(this.value) : radix = 16;

  @override
  String toString() {
    return stringifyInstance("NumberToken", fields: {
      "value": value,
      "radix": radix,
    });
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NumberToken &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          radix == other.radix;

  @override
  int get hashCode => value.hashCode ^ radix.hashCode;

  @override
  bool isMatchingToken(Token? other) => other is NumberToken;
}

class LineCommentToken extends Token {
  final String value;
  final String rawValue;

  LineCommentToken(this.value, this.rawValue);

  @override
  String toString() {
    return stringifyInstance("LineCommentToken", fields: {
      "value": value,
      "rawValue": rawValue,
    });
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LineCommentToken &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          rawValue == other.rawValue;

  @override
  int get hashCode => value.hashCode ^ rawValue.hashCode;

  @override
  bool isMatchingToken(Token? other) => other is LineCommentToken;
}

class MultiLineCommentToken extends Token {
  final String value;
  final String rawValue;

  MultiLineCommentToken(this.value, this.rawValue);

  @override
  String toString() {
    return stringifyInstance("MultiLineCommentToken", fields: {
      "value": value,
      "rawValue": rawValue,
    });
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MultiLineCommentToken &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          rawValue == other.rawValue;

  @override
  int get hashCode => value.hashCode ^ rawValue.hashCode;

  @override
  bool isMatchingToken(Token? other) => other is MultiLineCommentToken;
}

class DocumentationCommentToken extends Token {
  final String value;
  final String rawValue;

  DocumentationCommentToken(this.value, this.rawValue);

  @override
  String toString() {
    return stringifyInstance("DocumentationCommentToken", fields: {
      "value": value,
      "rawValue": rawValue,
    });
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentationCommentToken &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          rawValue == other.rawValue;

  @override
  int get hashCode => value.hashCode ^ rawValue.hashCode;

  @override
  bool isMatchingToken(Token? other) => other is DocumentationCommentToken;
}
