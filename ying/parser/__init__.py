from parsita import lit, ParserContext, reg

from ying.ast.comments import LineComment, MultiLineComment


class CommentParser(ParserContext, whitespace=r"\s*"):
    line_comment = reg(r"\/\/.*") > LineComment

    multi_line_comment = (
        reg(r"/[*]([^*]|([*][^/]))*[*]+/") > MultiLineComment.from_parser
    )


class KeywordParser(ParserContext, whitespace=r"\s*"):
    kw_import = lit("import")
    kw_from = lit("from")
    kw_export = lit("export")
    kw_struct = lit("struct")
    kw_class = lit("class")


class SpecialCharacterParser(ParserContext, whitespace=r"\s*"):
    parenthesis_open = lit("(")
    parenthesis_close = lit(")")

    curly_open = lit("{")
    curly_close = lit("}")

    angel_open = lit("<")
    angel_close = lit(">")


class CommonParser(ParserContext, whitespace=r"\s*"):
    identifier = reg(r"[a-zA-Z_]*")
    string = reg(r"\"([^\"\\]|\\[\s\S])*\"")
    char = reg(r"'([a-zA-Z0-9]|\\[a-zA-Z])'")
    boolean = lit("true") | lit("false")
    integer = reg(r"[0-9][0-9_]*")
    float = reg(r"[0-9][0-9_]*\.[0-9][0-9_]*")
