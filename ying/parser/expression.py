from parsita import ParserContext, fwd, lit, opt, rep

from ying.ast.expression import NumericExpression, UnaryExpression
from ying.parser.common import CommonParser
from ying.parser.special_character import SpecialCharacterParser


class ExpressionParser(ParserContext, whitespace=r"\s*"):
    number = CommonParser.float | CommonParser.integer

    additive_expression = fwd()
    unit = number | (lit("(") >> additive_expression << lit(")"))
    unary = (
        opt(SpecialCharacterParser.plus | SpecialCharacterParser.minus) & unit
    ) > UnaryExpression.parse
    multiplicative_expression = fwd()

    additive_expression.define(
        (
            multiplicative_expression
            & rep(
                (SpecialCharacterParser.plus | SpecialCharacterParser.minus)
                & multiplicative_expression
            )
        )
        > NumericExpression.parse
    )

    multiplicative_expression.define(
        (
            unary
            & rep(
                (
                    SpecialCharacterParser.asterisk
                    | SpecialCharacterParser.slash
                    | SpecialCharacterParser.percent
                )
                & unary
            )
        )
        > NumericExpression.parse
    )

    numeric_expression = additive_expression
