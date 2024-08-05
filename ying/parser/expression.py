from parsita import ParserContext, fwd, lit, opt, rep

from ying.ast.expression import BinaryExpression, UnaryExpression
from ying.parser.common import CommonParser
from ying.parser.special_character import SpecialCharacterParser


class ExpressionParser(ParserContext, whitespace=r"\s*"):
    expression = fwd()

    unit = (CommonParser.literal | CommonParser.identifier) | (
        lit("(") >> expression << lit(")")
    )

    unary = (
        opt(
            SpecialCharacterParser.plus
            | SpecialCharacterParser.minus
            | SpecialCharacterParser.exclamation_mark
        )
        & unit
    ) > UnaryExpression.parse

    multiplicative_expression = (
        unary
        & rep(
            (
                SpecialCharacterParser.asterisk
                | SpecialCharacterParser.slash
                | SpecialCharacterParser.percent
            )
            & unary
        )
    ) > BinaryExpression.parse

    additive_expression = (
        multiplicative_expression
        & rep(
            (SpecialCharacterParser.plus | SpecialCharacterParser.minus)
            & multiplicative_expression
        )
    ) > BinaryExpression.parse

    comparsive_expression = (
        additive_expression
        & rep(
            (
                CommonParser.strict_equal
                | CommonParser.strict_unequal
                | SpecialCharacterParser.angel_close
                | SpecialCharacterParser.angel_open
                | CommonParser.greater_than_or_equal
                | CommonParser.less_than_or_equal
            )
            & additive_expression
        )
    ) > BinaryExpression.parse

    expression.define(comparsive_expression)
