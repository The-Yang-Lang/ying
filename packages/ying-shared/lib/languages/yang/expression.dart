import 'package:ying_shared/located_token.dart';
import 'package:ying_shared/languages/yang/type.dart';
import 'package:ying_shared/utils/stringify.dart';

abstract class Expression {
  @override
  String toString() => stringifyInstance("Expression");
}

class IdentifierExpression extends Expression {
  final String value;

  IdentifierExpression(this.value);

  @override
  String toString() => stringifyInstance("IdentifierExpression", fields: {
        "value": value,
      });
}

abstract class Statement {
  @override
  String toString() => stringifyInstance("Statement");
}

class ExportStatement extends Statement {
  final Statement expression;

  ExportStatement(this.expression);

  @override
  String toString() => stringifyInstance("ExportExpression", fields: {
        "expression": expression,
      });

  static (int, ExportStatement)? fromTokens(
    List<LocatedToken> locatedTokens,
    int currentPosition,
  ) {
    return null;
  }
}

class TypeStatement extends Statement {
  Type identifier;

  Expression typeExpression;

  TypeStatement(this.identifier, this.typeExpression);

  @override
  String toString() => stringifyInstance("TypeStatement", fields: {
        "identifier": identifier,
        "typeExpression": typeExpression,
      });
}
