from parsita import ParserContext, reg

from ying.ast.comments import LineComment, MultiLineComment


class CommentParser(ParserContext, whitespace=r"\s*"):
    line_comment = reg(r"\/\/.*") > LineComment

    multi_line_comment = reg(r"\/[*]([^*]|([*][^\/]))*[*]+\/") > MultiLineComment.parse

    documentation_comment = (
        reg(r"\/\*\*([^*]|([*][^\/]))*[*]+\/") > MultiLineComment.parse
    )
