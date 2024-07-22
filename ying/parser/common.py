from parsita import lit, ParserContext, reg

from ying.parser.special_character import SpecialCharacterParser
from ying.shared.utils import join_parser_parts


class CommonParser(ParserContext, whitespace=r"\s*"):
    identifier = reg(r"[a-zA-Z_][a-zA-Z0-9_]*")
    string = reg(r"\"([^\"\\]|\\[\s\S])*\"")
    char = reg(r"'([a-zA-Z0-9]|\\[a-zA-Z])'")
    boolean = lit("true") | lit("false")
    integer = reg(r"[0-9][0-9_]*")
    float = reg(r"[0-9][0-9_]*\.[0-9][0-9_]*")

    # Comparison operators

    strict_equal = (
        SpecialCharacterParser.equal_sign & SpecialCharacterParser.equal_sign
        > join_parser_parts
    )

    strict_unequal = (
        SpecialCharacterParser.exclamation_mark & SpecialCharacterParser.equal_sign
    ) > join_parser_parts
