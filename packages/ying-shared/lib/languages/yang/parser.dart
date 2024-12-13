import 'package:ying_shared/languages/yang/expression.dart';
import 'package:ying_shared/languages/yang/parser_error.dart';
import 'package:ying_shared/languages/yang/type.dart';
import 'package:ying_shared/languages/yang/type_argument.dart';
import 'package:ying_shared/lexer.dart';
import 'package:ying_shared/located_token.dart';
import 'package:ying_shared/logging/logger.dart';
import 'package:ying_shared/source_file.dart';
import 'package:ying_shared/token.dart';

abstract class Frontend {}

class YangFrontend extends Frontend {
  Logger logger = Logger.withSimpleNameFromEnv("YangFrontend");

  List<LocatedToken> locatedTokens;

  int currentIndex = 0;

  YangFrontend(this.locatedTokens);

  LocatedToken? getLocatedTokenAtIndex(int index) {
    if (index < 0) {
      return null;
    }

    if (index >= locatedTokens.length) {
      return null;
    }

    return locatedTokens[index];
  }

  Token? getTokenAtIndex(int index) {
    return getLocatedTokenAtIndex(index)?.token;
  }

  LocatedToken? get currentLocatedToken => getLocatedTokenAtIndex(currentIndex);

  Token? get currentToken => currentLocatedToken?.token;

  LocatedToken? peek({
    int offset = 1,
  }) {
    return locatedTokens[currentIndex + offset];
  }

  void advance({int amount = 1}) {
    currentIndex += amount;
  }

  List<Statement> parse() {
    final result = <Statement>[];

    while (currentIndex < locatedTokens.length) {
      result.add(_parseStatement());
    }

    return result;
  }

  /// Parses a top-level statement.
  Statement _parseStatement() {
    logger.trace(
      "Trying to parse a top-level statement based on token: $currentToken",
    );

    switch (currentToken) {
      case null:
        throw UnexpectedEndOfFileException();

      case KeywordToken(value: "export"):
        return _parseExportStatement();

      case KeywordToken(value: "import"):
        // TODO: Parse import statement
        break;

      case KeywordToken(value: "type"):
        return _parseTypeStatement();
    }

    throw UnexpectedTokenException(
      KeywordToken("export | import | type"),
      currentToken,
    );
  }

  ExportStatement _parseExportStatement() {
    logger.debug("Parsing export statement");

    // Skip the export keyword
    advance();

    final subStatement = _parseStatement();

    return ExportStatement(subStatement);
  }

  bool isUpcomingToken(Token token, {int offset = 0}) {
    final tokenAtIndex = peek(offset: offset)?.token;

    return token.isMatchingToken(tokenAtIndex);
  }

  TypeStatement _parseTypeStatement() {
    logger.debug("Parsing type statement");

    // Skip the type keyword
    advance();

    if (currentToken is! IdentifierToken) {
      throw UnexpectedTokenException(
        IdentifierToken("<identifier name>"),
        currentToken,
      );
    }

    final identifier = _parseIdentifier();

    if (SpecialCharacterToken("=").isMatchingToken(currentToken) == false) {
      throw UnexpectedTokenException(
        SpecialCharacterToken("="),
        currentToken,
      );
    }

    final typeExpression = _parseIdentifier();

    if (SpecialCharacterToken(";").isMatchingToken(currentToken) == false) {
      throw UnexpectedTokenException(
        SpecialCharacterToken(";"),
        currentToken,
      );
    }

    return TypeStatement(identifier, typeExpression);
  }

  Type _parseIdentifier() {
    logger.debug("Parsing identifier");

    if (currentToken is! IdentifierToken) {
      throw UnexpectedTokenException(
        IdentifierToken("<identifier name>"),
        currentToken,
      );
    }

    final identifierName = (currentToken as IdentifierToken).value;
    final builder = TypeBuilder(identifierName);

    // Skipe the identifier name
    advance();

    if (SpecialCharacterToken("<").isMatchingToken(currentToken)) {
      logger.trace("Found opening of type arguments");
      advance();
    }

    return builder.build();
  }

  TypeArgument _parseTypeArgument() {
    logger.debug("Parsing type argument");

    if (currentToken is! IdentifierToken) {
      throw UnexpectedTokenException(
        IdentifierToken("<identifier name>"),
        currentToken,
      );
    }

    final identifier = (currentToken as IdentifierToken).value;

    // Skip the type argument name
    advance();

    return TypeArgument(identifier);
  }

  List<LocatedToken> readUntil(Token exitToken) {
    final result = <LocatedToken>[];

    while (exitToken.isMatchingToken(currentToken) == false) {
      if (currentLocatedToken == null) {
        break;
      }

      result.add(currentLocatedToken!);
      advance();
    }

    return result;
  }

  List<List<LocatedToken>> separateTokensBy(
    List<LocatedToken> tokens,
    Token separatorToken,
  ) {
    final result = <List<LocatedToken>>[];
    final temporaryResult = <LocatedToken>[];

    for (var i = 0; i < tokens.length; i++) {
      if (separatorToken.isMatchingToken(tokens[i].token)) {
        result.add(temporaryResult);
        temporaryResult.clear();

        continue;
      }

      temporaryResult.add(tokens[i]);
    }

    return result;
  }

  /// Tokenizes and parses the given Yang [sourceFile].
  static List<Statement> parseFromSourceFile(
    SourceFile sourceFile,
  ) {
    final lexer = Lexer.yangLexer(sourceFile);
    final tokens = lexer.tokenize();
    final frontend = YangFrontend(tokens);

    return frontend.parse();
  }
}
