from parsita import Success

from ying.ast.expression import NumericExpression
from ying.ast.literals import IntegerLiteral
from ying.parser.expression import ExpressionParser

# region numeric expressions


def test_parse_numeric_expression_with_plus():
    result = ExpressionParser.numeric_expression.parse("1 + 1")

    assert result == Success(
        NumericExpression(
            IntegerLiteral(1),
            "+",
            IntegerLiteral(1),
        )
    )


def test_parse_numeric_expression_with_minus():
    result = ExpressionParser.numeric_expression.parse("1 - 1")

    assert result == Success(
        NumericExpression(
            IntegerLiteral(1),
            "-",
            IntegerLiteral(1),
        )
    )


def test_parse_numeric_expression_with_multiplication():
    result = ExpressionParser.numeric_expression.parse("1 * 1")

    assert result == Success(
        NumericExpression(
            IntegerLiteral(1),
            "*",
            IntegerLiteral(1),
        )
    )


def test_parse_numeric_expression_with_division():
    result = ExpressionParser.numeric_expression.parse("1 / 1")

    assert result == Success(
        NumericExpression(
            IntegerLiteral(1),
            "/",
            IntegerLiteral(1),
        )
    )


def test_parse_numeric_expression_with_modulo():
    result = ExpressionParser.numeric_expression.parse("1 % 1")

    assert result == Success(
        NumericExpression(
            IntegerLiteral(1),
            "%",
            IntegerLiteral(1),
        )
    )


def test_precedence_of_multiplication():
    result = ExpressionParser.numeric_expression.parse("1 * 2 + 3")

    assert result == Success(
        NumericExpression(
            NumericExpression(
                IntegerLiteral(1),
                "*",
                IntegerLiteral(2),
            ),
            "+",
            IntegerLiteral(3),
        )
    )


def test_parse_numeric_expression_with_precedence():
    result = ExpressionParser.numeric_expression.parse("1 + 2 * 3")

    assert result == Success(
        NumericExpression(
            IntegerLiteral(1),
            "+",
            NumericExpression(
                IntegerLiteral(2),
                "*",
                IntegerLiteral(3),
            ),
        )
    )


def test_parse_numeric_expression_with_parenthesis():
    result = ExpressionParser.numeric_expression.parse("(1 + 2) * 3")

    assert result == Success(
        NumericExpression(
            NumericExpression(IntegerLiteral(1), "+", IntegerLiteral(2)),
            "*",
            IntegerLiteral(3),
        ),
    )


def test_another_expression():
    result = ExpressionParser.numeric_expression.parse("3 - 2 - 1")

    assert result == Success(
        NumericExpression(
            NumericExpression(
                IntegerLiteral(3),
                "-",
                IntegerLiteral(2),
            ),
            "-",
            IntegerLiteral(1),
        )
    )


def test_comparison():
    result = ExpressionParser.numeric_expression.parse("1 + 2 == 3 * 4")

    assert result == Success(
        NumericExpression(
            NumericExpression(
                IntegerLiteral(1),
                "+",
                IntegerLiteral(2),
            ),
            "==",
            NumericExpression(
                IntegerLiteral(3),
                "*",
                IntegerLiteral(4),
            ),
        )
    )


# endregion
