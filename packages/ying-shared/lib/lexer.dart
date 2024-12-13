import 'package:ying_shared/lexer_errors.dart';
import 'package:ying_shared/literal_type.dart';
import 'package:ying_shared/located_token.dart';
import 'package:ying_shared/source_file.dart';
import 'package:ying_shared/text_location.dart';
import 'package:ying_shared/text_span.dart';
import 'package:ying_shared/token.dart';

final _yangKeywords = [
  // module system
  "import",
  "from",
  "export",

  // defining types + data structures
  "type",
  "struct",
  "class",
  "interface",

  // class modifiers
  "abstract",
  "final",

  // visibility modifiers
  "public",
  "protected",
  "private",

  // variables + constants
  "var",
  "const",

  // control flow
  "if",
  "else",
  "while",
  "for",
  "foreach",
  "in",
  "return",
];

final _yangSpecialCharacters = [
  "(",
  ")",
  "[",
  "]",
  "{",
  "}",
  ".",
  ":",
  ",",
  ";",
  "?",
  "!",
  "+",
  "-",
  "*",
  "/",
  "%",
  "=",
  "&",
  "|",
  "<",
  ">",
  "~",
];

class Lexer {
  /// The [SourceFile] which should be tokenized
  SourceFile sourceFile;

  /// The list of language keywords
  final List<String> _keywords;

  /// The list of special characters
  final List<String> _specialCharacters;

  /// Whether to handle spaces as special characters
  final bool _handleSpaceAsSpecialCharacter;

  /// Whether to handle tabs as special characters
  final bool _handleTabAsSpecialCharacter;

  /// Whether to handle newlines as special characters
  final bool _handleNewlineAsSpecialCharacter;

  final List<String> _stringOpeningCharacters;
  final List<String> _characterOpeningCharacters;
  final List<String> _interpolatableStringOpeningCharacters;

  final List<List<String>> _lineCommentStartingCharacters;
  final List<(List<String>, List<String>)> _multiLineCommentStartingCharacters;

  /// The current location of the [Lexer]
  TextLocation _currentLocation = TextLocation.withDefaults();

  /// The internal buffer which stores found characters
  final List<String> _buffer = <String>[];

  /// The list of [LocatedToken]s which have been found during the lexing
  /// process
  final List<LocatedToken> _foundTokens = <LocatedToken>[];

  /// The start location of the [_buffer] contents.
  ///
  /// This is used for determining the [TextSpan] when handling the buffer
  /// contents.
  TextLocation? _bufferStartLocation;

  Lexer(
    this.sourceFile, {
    required List<String> keywords,
    required List<String> specialCharacters,
    required List<String> stringOpeningCharacters,
    required List<String> characterOpeningCharacters,
    required List<String> interpolatableStringOpeningCharacters,
    required List<List<String>> lineCommentStartingCharacters,
    required List<(List<String>, List<String>)>
        multiLineCommentStartingCharacters,
    required List<(List<String>, List<String>)>
        documentationCommentStartingCharacters,
    bool handleSpaceAsSpecialCharacter = false,
    bool handleTabAsSpecialCharacter = false,
    bool handleNewlineAsSpecialCharacter = false,
  })  : _multiLineCommentStartingCharacters =
            multiLineCommentStartingCharacters,
        _lineCommentStartingCharacters = lineCommentStartingCharacters,
        _interpolatableStringOpeningCharacters =
            interpolatableStringOpeningCharacters,
        _characterOpeningCharacters = characterOpeningCharacters,
        _stringOpeningCharacters = stringOpeningCharacters,
        _handleNewlineAsSpecialCharacter = handleNewlineAsSpecialCharacter,
        _handleTabAsSpecialCharacter = handleTabAsSpecialCharacter,
        _handleSpaceAsSpecialCharacter = handleSpaceAsSpecialCharacter,
        _specialCharacters = specialCharacters,
        _keywords = keywords;

  Lexer.yangLexer(this.sourceFile)
      : _keywords = _yangKeywords,
        _specialCharacters = _yangSpecialCharacters,
        _stringOpeningCharacters = ['"'],
        _characterOpeningCharacters = ["'"],
        _interpolatableStringOpeningCharacters = ["`"],
        _lineCommentStartingCharacters = [
          ["/", "/"]
        ],
        _multiLineCommentStartingCharacters = [
          (["/", "*"], ["*", "/"])
        ],
        _handleSpaceAsSpecialCharacter = false,
        _handleTabAsSpecialCharacter = false,
        _handleNewlineAsSpecialCharacter = false;

  /// Handles the contents of the internal buffer and clears the [_buffer]
  /// contents including the [_bufferStartLocation].
  ///
  /// It adds the found token to the end of the [_foundTokens] list.
  ///
  /// It throws an exception if the [_bufferStartLocation] is null.
  void _handleBuffer() {
    if (_buffer.isEmpty) {
      return;
    }

    if (_bufferStartLocation == null) {
      throw Exception("Buffer start location is null");
    }

    final joinedBufferContents = _buffer.join();

    final span = TextSpan(
      _bufferStartLocation!.clone(),
      _currentLocation.clone(),
    );

    Token token;

    if (_keywords.contains(joinedBufferContents)) {
      token = KeywordToken(joinedBufferContents);
    } else {
      token = IdentifierToken(joinedBufferContents);
    }

    _foundTokens.add(LocatedToken(token, span));
    _buffer.clear();
    _bufferStartLocation = null;
  }

  /// Adds the given character to the internal buffer and sets the
  /// [_bufferStartLocation] when it is null
  void _addCharacterToBuffer(String character) {
    _addCharactersToBuffer([character]);
  }

  /// Adds the given characters to the internal buffer and sets the
  /// [_bufferStartLocation] when it is null
  void _addCharactersToBuffer(List<String> characters) {
    _bufferStartLocation ??= _currentLocation.clone();

    _buffer.addAll(characters);
  }

  /// This method retrieves a character from the [sourceFile] located at an
  /// offset defined by the [amount] parameter, relative to the current position
  /// in [_currentLocation].
  ///
  /// - If the `amount` is positive, it peeks forward.
  /// - If the `amount` is negative, it peeks backward.
  /// - If the resulting position is out of bounds, null is returned.
  ///
  /// ### Example:
  /// ```dart
  /// // Assuming `currentLocation.position` is 5:
  /// String? char = _peek(2);  // Peeks at the character at position 7.
  /// String? char = _peek(0);  // Peeks at the character at position 5.
  /// String? char = _peek(-3); // Peeks at the character at position 2.
  /// ```
  String? _peek(int amount) => sourceFile.getCharacterAtPosition(
        _currentLocation.position + amount,
      );

  /// Resets the internal state of the [Lexer]
  ///
  /// This means:
  /// - the [_buffer] gets cleared
  /// - the [_currentLocation] will be set to its initial position
  /// - the [_foundTokens] will be cleared
  /// - the [_bufferStartLocation] will be set to null
  void _reset() {
    _buffer.clear();
    _currentLocation = TextLocation.withDefaults();
    _foundTokens.clear();
    _bufferStartLocation = null;
  }

  /// Tokenizes a literal with the given [literalType] surrounded by the
  /// [surroundingCharacter].
  ///
  /// It supports escaped characters within the literal and ensures proper
  /// handling of unterminated literals.
  void _tokenizeLiteral(String surroundingCharacter, LiteralType literalType) {
    // Handle the buffer in case it contains any data
    _handleBuffer();

    // Add the surrounding starting character to the buffer
    _addCharacterToBuffer(surroundingCharacter);

    // Increment the current location by one
    // Otherwise we would end up with an empty literal since the current
    // location will point to the surrounding starting character
    _currentLocation.advance(1);

    while (_currentLocation.position < sourceFile.contentLength) {
      final currentCharacter = _peek(0);

      if (currentCharacter == null) {
        // We reached the end of file

        break;
      }

      if (_isNextCharacterEscaped()) {
        _addCharacterToBuffer(currentCharacter);
        _currentLocation.advance(1);

        continue;
      }

      if (currentCharacter == surroundingCharacter) {
        // We found the closing surrounding character and it is not escaped
        _addCharacterToBuffer(currentCharacter);

        final textSpan = TextSpan(_bufferStartLocation!, _currentLocation);
        Token token;

        final rawValue = _buffer.join();
        final value = rawValue.substring(1, rawValue.length - 1);

        switch (literalType) {
          case LiteralType.string:
            token = StringToken(value, rawValue);
            break;
          case LiteralType.interpolatableString:
            token = InterpolatableStringToken(value, rawValue);
            break;
          case LiteralType.char:
            token = CharacterToken(value, rawValue);
            break;
        }

        _foundTokens.add(LocatedToken(token, textSpan));
        _currentLocation.advance(1);
        _buffer.clear();
        _bufferStartLocation = null;

        return;
      }

      // Add the current character to the buffer and increment the current
      // location
      _addCharacterToBuffer(currentCharacter);
      _currentLocation.advance(1);
    }

    throw UnterminatedLiteralException(literalType, _bufferStartLocation!);
  }

  /// Returns true when the next character is escaped
  ///
  /// This means the last character in the buffer is a backslash
  bool _isNextCharacterEscaped() => _buffer.lastOrNull == "\\";

  /// Checks if the upcoming characters in the source file match a given sequence.
  ///
  /// This method verifies whether the sequence of characters starting from the
  /// current position in the source file matches the provided list of
  /// `characters`. The comparison is performed sequentially, where the first
  /// character in the list corresponds to the current position, the second to
  /// the next, and so on.
  bool _hasUpcomingCharacters(List<String> characters) {
    for (var index = 0; index < characters.length; index++) {
      if (_peek(index) == characters[index]) {
        continue;
      }

      return false;
    }

    return true;
  }

  /// Tokenizes a line comment in the [sourceFile].
  ///
  /// This method processes a line comment starting with a specific sequence
  /// (e.g., `//` or `#`), capturing the comment text until the end of the line.
  ///
  /// The resulting token is stored in [_foundTokens] as a [LineCommentToken].
  void _tokenizeLineComment(List<String> startingSequence) {
    // Handle any previous buffer contents
    _handleBuffer();

    _addCharactersToBuffer(startingSequence);
    _currentLocation.advance(startingSequence.length);

    while (_currentLocation.position < sourceFile.contentLength) {
      final currentCharacter = _peek(0)!;

      if (currentCharacter == "\r") {
        _currentLocation.advance(1);

        continue;
      }

      if (currentCharacter == "\n") {
        // Found end of line
        break;
      }

      _addCharacterToBuffer(currentCharacter);
      _currentLocation.advance(1);
    }

    final endLocation = _currentLocation.clone();
    final rawValue = _buffer.join();
    final value = rawValue.substring(startingSequence.length);

    _foundTokens.add(
      LocatedToken(
        LineCommentToken(value, rawValue),
        TextSpan(_bufferStartLocation!, endLocation),
      ),
    );

    _bufferStartLocation = null;
    _buffer.clear();
  }

  /// Tokenizes a multi-line comment in the [sourceFile].
  ///
  /// This method processes a multi-line comment delimited by a specific start
  /// and end sequence (e.g., `/*` and `*/` for C-style comments).
  /// It captures the comment's content and stores it as a
  /// [MultiLineCommentToken] in [_foundTokens].
  void _tokenizeMultiLineComment(
    (List<String>, List<String>) characterSequences,
  ) {
    // Handle any previous buffer contents
    _handleBuffer();

    final startSequence = characterSequences.$1;
    final endSequence = characterSequences.$2;

    _addCharactersToBuffer(startSequence);
    _currentLocation.advance(startSequence.length);

    while (_currentLocation.position < sourceFile.contentLength) {
      final currentCharacter = _peek(0)!;

      if (_isNextCharacterEscaped()) {
        _addCharacterToBuffer(currentCharacter);
        _currentLocation.advance(1);

        continue;
      } else if (currentCharacter == "\n") {
        _addCharacterToBuffer(currentCharacter);
        _currentLocation.handleNewline();

        continue;
      } else if (_hasUpcomingCharacters(endSequence)) {
        // Found the end of the multi-line comment
        _currentLocation.advance(endSequence.length);
        _addCharactersToBuffer(endSequence);

        final endLocation = _currentLocation.clone();
        final rawValue = _buffer.join();
        final value = rawValue.substring(
          startSequence.length,
          rawValue.length - endSequence.length,
        );

        _foundTokens.add(
          LocatedToken(
            MultiLineCommentToken(value, rawValue),
            TextSpan(_bufferStartLocation!, endLocation),
          ),
        );

        _buffer.clear();
        _bufferStartLocation = null;

        return;
      }

      _addCharacterToBuffer(currentCharacter);
      _currentLocation.advance(1);
    }
  }

  /// Returns the tokens for the current [sourceFile]
  ///
  /// A second call to this function will tokenize the file again.
  List<LocatedToken> tokenize() {
    _reset();

    while (_currentLocation.position < sourceFile.contentLength) {
      // The current character can't be null since we are in the boundaries of
      // the source file
      final currentCharacter = _peek(0)!;

      switch (currentCharacter) {
        case " ":
          _handleBuffer();

          if (_handleSpaceAsSpecialCharacter) {
            _foundTokens.add(
              LocatedToken(
                SpecialCharacterToken(currentCharacter),
                TextSpan(
                  _currentLocation.clone(),
                  _currentLocation.clone()..advance(1),
                ),
              ),
            );
          }

          _currentLocation.advance(1);
          break;

        case "\t":
          _handleBuffer();

          if (_handleTabAsSpecialCharacter) {
            _foundTokens.add(
              LocatedToken(
                SpecialCharacterToken(currentCharacter),
                TextSpan(
                  _currentLocation.clone(),
                  _currentLocation.clone()..advance(1),
                ),
              ),
            );
          }

          _currentLocation.advance(1);
          break;

        case "\r":
          _handleBuffer();

          // Intentionally ignore \r character from Windows newlines

          _currentLocation.advance(1);
          break;

        case "\n":
          _handleBuffer();

          if (_handleNewlineAsSpecialCharacter) {
            _foundTokens.add(
              LocatedToken(
                SpecialCharacterToken(currentCharacter),
                TextSpan(
                  _currentLocation.clone(),
                  _currentLocation.clone()..advance(1),
                ),
              ),
            );
          }

          _currentLocation.handleNewline();
          break;

        default:
          if (_stringOpeningCharacters.contains(currentCharacter)) {
            _tokenizeLiteral(currentCharacter, LiteralType.string);
          } else if (_interpolatableStringOpeningCharacters
              .contains(currentCharacter)) {
            _tokenizeLiteral(
              currentCharacter,
              LiteralType.interpolatableString,
            );
          } else if (_characterOpeningCharacters.contains(currentCharacter)) {
            _tokenizeLiteral(currentCharacter, LiteralType.char);
          } else {
            var foundLineCommentCharactersSequence =
                _lineCommentStartingCharacters
                    .where(
                      (List<String> characterSequence) =>
                          _hasUpcomingCharacters(characterSequence),
                    )
                    .firstOrNull;

            if (foundLineCommentCharactersSequence != null) {
              _tokenizeLineComment(foundLineCommentCharactersSequence);

              break;
            }

            var foundMultiLineCommandCharactersSequence =
                _multiLineCommentStartingCharacters
                    .where(((List<String>, List<String>) entry) {
              return _hasUpcomingCharacters(entry.$1);
            }).firstOrNull;

            if (foundMultiLineCommandCharactersSequence != null) {
              _tokenizeMultiLineComment(
                foundMultiLineCommandCharactersSequence,
              );

              break;
            }

            if (_specialCharacters.contains(currentCharacter)) {
              _handleBuffer();

              _foundTokens.add(
                LocatedToken(
                  SpecialCharacterToken(currentCharacter),
                  TextSpan(
                    _currentLocation.clone(),
                    _currentLocation.clone()..advance(1),
                  ),
                ),
              );

              _currentLocation.advance(1);

              break;
            }

            // The current character is not a special character and it is not
            // part of a start sequence for line comments or multi-line comments
            _addCharacterToBuffer(currentCharacter);
            _currentLocation.advance(1);
          }

          break;
      }
    }

    // Handle the buffer one last time in case it has any leftover contents
    _handleBuffer();

    return _foundTokens;
  }
}
