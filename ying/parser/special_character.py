from parsita import lit, ParserContext


class SpecialCharacterParser(ParserContext, whitespace=r"\s*"):
    parenthesis_open = lit("(")
    parenthesis_close = lit(")")

    bracket_open = lit("[")
    bracket_close = lit("]")

    curly_open = lit("{")
    curly_close = lit("}")

    angel_open = lit("<")
    angel_close = lit(">")

    dot = lit(".")

    plus = lit("+")
    minus = lit("-")
    asterisk = lit("*")
    slash = lit("/")
    percent = lit("%")

    colon = lit(":")
    semicolon = lit(";")
    comma = lit(",")
    equal_sign = lit("=")
    question_mark = lit("?")
    exclamation_mark = lit("!")
    ampersand = lit("&")
    pipe = lit("|")
