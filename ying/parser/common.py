from parsita import ParserContext, fwd, lit, reg

from ying.ast.literals import (
    BooleanLiteral,
    CharLiteral,
    FloatLiteral,
    IntegerLiteral,
    StringLiteral,
)
from ying.parser.special_character import SpecialCharacterParser
from ying.shared.utils import join_parser_parts


class CommonParser(ParserContext, whitespace=r"\s*"):
    identifier = reg(r"[a-zA-Z_][a-zA-Z0-9_]*")
    string = reg(r"\"([^\"\\]|\\[\s\S])*\"") > StringLiteral.parse
    char = reg(r"'([a-zA-Z0-9]|\\[a-zA-Z])'") > CharLiteral.parse
    boolean = (lit("true") | lit("false")) > BooleanLiteral
    integer = reg(r"[0-9][0-9_]*") > IntegerLiteral.parse
    hexadecimal_integer = reg(r"0x[0-9A-Fa-f][0-9A-Fa-f_]*") > IntegerLiteral.parse
    octal_integer = reg(r"0o[0-7][0-7]*") > IntegerLiteral.parse
    float = reg(r"[0-9][0-9_]*\.[0-9][0-9_]*") > FloatLiteral.parse

    number = float | octal_integer | hexadecimal_integer | integer

    literal = string | char | boolean | number

    expression = fwd()

    expression.define(literal)

    # Comparison operators

    strict_equal = (
        SpecialCharacterParser.equal_sign & SpecialCharacterParser.equal_sign
        > join_parser_parts
    )

    strict_unequal = (
        SpecialCharacterParser.exclamation_mark & SpecialCharacterParser.equal_sign
    ) > join_parser_parts
