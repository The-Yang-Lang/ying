import 'package:test/test.dart';
import 'package:ying_shared/lexer.dart';
import 'package:ying_shared/lexer_errors.dart';
import 'package:ying_shared/literal_type.dart';
import 'package:ying_shared/located_token.dart';
import 'package:ying_shared/source_file.dart';
import 'package:ying_shared/text_location.dart';
import 'package:ying_shared/text_span.dart';
import 'package:ying_shared/token.dart';

void main() {
  group('Lexer', () {
    group('tokenize/0', () {
      test('it should tokenize a keyword', () {
        final sourceFile = SourceFile("test://test.ya", "type");
        final lexer = Lexer.yangLexer(sourceFile);
        final result = lexer.tokenize();

        expect(result, [
          LocatedToken(
            KeywordToken("type"),
            TextSpan(
              TextLocation.withDefaults(),
              TextLocation(4, 4, 1),
            ),
          ),
        ]);
      });

      test('it should tokenize an identifier', () {
        final sourceFile = SourceFile("test://test.ya", "Test");
        final lexer = Lexer.yangLexer(sourceFile);
        final result = lexer.tokenize();

        expect(result, [
          LocatedToken(
            IdentifierToken("Test"),
            TextSpan(
              TextLocation.withDefaults(),
              TextLocation(4, 4, 1),
            ),
          ),
        ]);
      });

      test('it should tokenize a special character', () {
        final sourceFile = SourceFile("test://test.ya", "*");
        final lexer = Lexer.yangLexer(sourceFile);
        final result = lexer.tokenize();

        expect(result, [
          LocatedToken(
            SpecialCharacterToken("*"),
            TextSpan(
              TextLocation.withDefaults(),
              TextLocation(1, 1, 1),
            ),
          ),
        ]);
      });

      test("it should tokenize a string", () {
        final sourceFile = SourceFile("test://test.ya", '"hello, world!"');
        final lexer = Lexer.yangLexer(sourceFile);
        final result = lexer.tokenize();

        expect(result, [
          LocatedToken(
            StringToken("hello, world!", '"hello, world!"'),
            TextSpan(
              TextLocation.withDefaults(),
              TextLocation(15, 15, 1),
            ),
          ),
        ]);
      });

      test("it should tokenize an interpolatable string", () {
        final sourceFile = SourceFile("test://test.ya", '`hello, world!`');
        final lexer = Lexer.yangLexer(sourceFile);
        final result = lexer.tokenize();

        expect(result, [
          LocatedToken(
            InterpolatableStringToken("hello, world!", '`hello, world!`'),
            TextSpan(
              TextLocation.withDefaults(),
              TextLocation(15, 15, 1),
            ),
          ),
        ]);
      });

      test("it should tokenize a character", () {
        final sourceFile = SourceFile("test://test.ya", "'a'");
        final lexer = Lexer.yangLexer(sourceFile);
        final result = lexer.tokenize();

        expect(result, [
          LocatedToken(
            CharacterToken("a", "'a'"),
            TextSpan(
              TextLocation.withDefaults(),
              TextLocation(3, 3, 1),
            ),
          ),
        ]);
      });

      test("it should tokenize a string with escape character", () {
        final sourceFile = SourceFile("test://test.ya", "'\\''");
        final lexer = Lexer.yangLexer(sourceFile);
        final result = lexer.tokenize();

        expect(result, [
          LocatedToken(
            CharacterToken("\\'", "'\\''"),
            TextSpan(
              TextLocation.withDefaults(),
              TextLocation(4, 4, 1),
            ),
          ),
        ]);
      });

      test(
        "it should throw an exception when the literal is unterminated",
        () {
          final sourceFile = SourceFile("test://test.ya", '"unit test');
          final lexer = Lexer.yangLexer(sourceFile);

          expect(
            () {
              lexer.tokenize();
            },
            throwsA(
              UnterminatedLiteralException(
                LiteralType.string,
                TextLocation.withDefaults(),
              ),
            ),
          );
        },
      );

      group("comments", () {
        test("it should tokenize a line comment", () {
          final sourceFile = SourceFile(
            "test://test.ya",
            "// This is a line comment",
          );
          final lexer = Lexer.yangLexer(sourceFile);
          final result = lexer.tokenize();

          expect(result, [
            LocatedToken(
              LineCommentToken(
                " This is a line comment",
                "// This is a line comment",
              ),
              TextSpan(
                TextLocation.withDefaults(),
                TextLocation(25, 25, 1),
              ),
            ),
          ]);
        });

        test("it should tokenize a line comment with a trailing newline", () {
          final sourceFile = SourceFile(
            "test://test.ya",
            "// This is a line comment\n",
          );
          final lexer = Lexer.yangLexer(sourceFile);
          final result = lexer.tokenize();

          expect(result, [
            LocatedToken(
              LineCommentToken(
                " This is a line comment",
                "// This is a line comment",
              ),
              TextSpan(
                TextLocation.withDefaults(),
                TextLocation(25, 25, 1),
              ),
            ),
          ]);
        });

        test("it should tokenize a multi line comment", () {
          final sourceFile = SourceFile(
            "test://test.ya",
            """/**
  * This is a multi-line comment
  * that spans multiple lines.
*/""",
          );
          final lexer = Lexer.yangLexer(sourceFile);
          final result = lexer.tokenize();

          expect(result, [
            LocatedToken(
              MultiLineCommentToken(
                """*
  * This is a multi-line comment
  * that spans multiple lines.
""",
                """/**
  * This is a multi-line comment
  * that spans multiple lines.
*/""",
              ),
              TextSpan(
                TextLocation.withDefaults(),
                TextLocation(70, 2, 4),
              ),
            ),
          ]);
        });

        test(
          "it should tokenize a multi line comment with a leading newline",
          () {
            final sourceFile = SourceFile(
              "test://test.ya",
              """\n/**
  * This is a multi-line comment
  * that spans multiple lines.
*/""",
            );
            final lexer = Lexer.yangLexer(sourceFile);
            final result = lexer.tokenize();

            expect(result, [
              LocatedToken(
                MultiLineCommentToken(
                  """*
  * This is a multi-line comment
  * that spans multiple lines.
""",
                  """/**
  * This is a multi-line comment
  * that spans multiple lines.
*/""",
                ),
                TextSpan(
                  TextLocation(1, 0, 2),
                  TextLocation(71, 2, 5),
                ),
              ),
            ]);
          },
        );
      });
    });
  });
}
