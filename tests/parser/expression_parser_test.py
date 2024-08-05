from parsita import Success

from ying.ast.expression import BinaryExpression
from ying.ast.literals import IntegerLiteral
from ying.parser.expression import ExpressionParser

# region binary expressions


def test_parse_binary_expression_with_plus():
    result = ExpressionParser.expression.parse("1 + 1")

    assert result == Success(
        BinaryExpression(
            IntegerLiteral(1),
            "+",
            IntegerLiteral(1),
        )
    )


def test_parse_binary_expression_with_minus():
    result = ExpressionParser.expression.parse("1 - 1")

    assert result == Success(
        BinaryExpression(
            IntegerLiteral(1),
            "-",
            IntegerLiteral(1),
        )
    )


def test_parse_binary_expression_with_multiplication():
    result = ExpressionParser.expression.parse("1 * 1")

    assert result == Success(
        BinaryExpression(
            IntegerLiteral(1),
            "*",
            IntegerLiteral(1),
        )
    )


def test_parse_binary_expression_with_division():
    result = ExpressionParser.expression.parse("1 / 1")

    assert result == Success(
        BinaryExpression(
            IntegerLiteral(1),
            "/",
            IntegerLiteral(1),
        )
    )


def test_parse_binary_expression_with_modulo():
    result = ExpressionParser.expression.parse("1 % 1")

    assert result == Success(
        BinaryExpression(
            IntegerLiteral(1),
            "%",
            IntegerLiteral(1),
        )
    )


def test_precedance():
    result = ExpressionParser.expression.parse("1 * 2 + 3")

    assert result == Success(
        BinaryExpression(
            BinaryExpression(
                IntegerLiteral(1),
                "*",
                IntegerLiteral(2),
            ),
            "+",
            IntegerLiteral(3),
        )
    )


def test_precedance_even_more():
    result = ExpressionParser.expression.parse("1 + 2 * 3")

    assert result == Success(
        BinaryExpression(
            IntegerLiteral(1),
            "+",
            BinaryExpression(
                IntegerLiteral(2),
                "*",
                IntegerLiteral(3),
            ),
        )
    )


def test_parse_binary_expression_with_parenthesis():
    result = ExpressionParser.expression.parse("(1 + 2) * 3")

    assert result == Success(
        BinaryExpression(
            BinaryExpression(IntegerLiteral(1), "+", IntegerLiteral(2)),
            "*",
            IntegerLiteral(3),
        ),
    )


def test_parse_chained_subtraction():
    result = ExpressionParser.expression.parse("3 - 2 - 1")

    assert result == Success(
        BinaryExpression(
            BinaryExpression(
                IntegerLiteral(3),
                "-",
                IntegerLiteral(2),
            ),
            "-",
            IntegerLiteral(1),
        )
    )


def test_comparison():
    result = ExpressionParser.expression.parse("1 + 2 == 3 * 4")

    assert result == Success(
        BinaryExpression(
            BinaryExpression(
                IntegerLiteral(1),
                "+",
                IntegerLiteral(2),
            ),
            "==",
            BinaryExpression(
                IntegerLiteral(3),
                "*",
                IntegerLiteral(4),
            ),
        )
    )


# endregion
