import 'package:ying_shared/located_token.dart';
import 'package:ying_shared/token.dart';
import 'package:ying_shared/utils/stringify.dart';

abstract class ParserError implements Exception {}

class UnexpectedEndOfFileException extends ParserError {
  @override
  String toString() {
    return stringifyInstance("UnexpectedEndOfFileException");
  }
}

class InvalidTopLevelTokenException extends ParserError {
  final LocatedToken? actualToken;

  InvalidTopLevelTokenException(this.actualToken);

  @override
  String toString() {
    return stringifyInstance("InvalidTopLevelTokenException", fields: {
      "actualToken": actualToken,
    });
  }
}

class UnexpectedTokenException extends ParserError {
  final Token expectedToken;

  final Token? actualToken;

  UnexpectedTokenException(this.expectedToken, this.actualToken);

  @override
  String toString() {
    return stringifyInstance("UnexpectedTokenException", fields: {
      "expectedToken": expectedToken,
      "actualToken": actualToken,
    });
  }
}

class InvalidTokenSequenceException extends ParserError {
  final List<Token> expectedTokens;

  final List<Token> actualTokens;

  InvalidTokenSequenceException(this.expectedTokens, this.actualTokens);

  @override
  String toString() {
    return stringifyInstance("InvalidTokenSequenceException", fields: {
      "expectedTokens": expectedTokens,
      "actualTokens": actualTokens,
    });
  }
}
