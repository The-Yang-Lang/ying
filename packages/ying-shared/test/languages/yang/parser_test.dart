import 'package:result_type/result_type.dart';
import 'package:test/test.dart';
import 'package:ying_shared/languages/yang/expression.dart';
import 'package:ying_shared/languages/yang/parser.dart';
import 'package:ying_shared/languages/yang/parser_error.dart';
import 'package:ying_shared/lexer.dart';
import 'package:ying_shared/source_file.dart';

void main() {
  group('Parser >', () {
    group('parse/1 >', () {
      test('should return the export statement', () {
        final sourceFile =
            SourceFile("test://", "export type string = string;");
        final lexer = Lexer.yangLexer(sourceFile);
        final tokens = lexer.tokenize();
        final parser = YangFrontend(tokens);
        final result = parser.parse();

        expect(result, isA<Success>());

        final castedResult = (result as Success<List<Expression>, ParserError>);

        expect(castedResult.value, hasLength(1));
        expect(
          castedResult.value[0],
          ExportStatement(
            TypeStatement(
              "string",
              IdentifierExpression("string"),
            ),
          ),
        );
      });
    });
  });
}
