from parsita import fwd, lit, opt, ParserContext, reg, repsep
from parsita.util import splat

from ying.ast.comments import LineComment, MultiLineComment
from ying.ast.data_types import DataType, IntersectionDataType, UnionDataType
from ying.ast.statements import (
    ImportedAliasedIdentifier,
    ImportedIdentifier,
    ImportStatement,
    StructProperty,
    StructStatement,
)
from ying.shared.utils import join_parser_parts


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
    kw_type = lit("type")
    kw_as = lit("as")
    kw_extends = lit("extends")
    kw_implements = lit("implements")


class SpecialCharacterParser(ParserContext, whitespace=r"\s*"):
    parenthesis_open = lit("(")
    parenthesis_close = lit(")")

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


class CommonParser(ParserContext, whitespace=r"\s*"):
    identifier = reg(r"[a-zA-Z_]+")
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


class StatementParser(ParserContext, whitespace=r"\s*"):
    imported_identifier = CommonParser.identifier > ImportedIdentifier

    imported_aliased_identifier = (
        CommonParser.identifier << KeywordParser.kw_as & CommonParser.identifier
        > splat(ImportedAliasedIdentifier)
    )

    importable_identifiers = imported_aliased_identifier | imported_identifier

    import_statement = (
        KeywordParser.kw_import
        >> SpecialCharacterParser.curly_open
        >> opt(repsep(importable_identifiers, SpecialCharacterParser.comma))
        << SpecialCharacterParser.curly_close
        << KeywordParser.kw_from
        & CommonParser.string << SpecialCharacterParser.semicolon
    ) > splat(ImportStatement.parse)

    struct_property = (
        CommonParser.identifier << SpecialCharacterParser.colon
        & CommonParser.identifier
    ) > splat(StructProperty)

    struct_statement = (
        KeywordParser.kw_struct >> CommonParser.identifier
        & opt(
            SpecialCharacterParser.angel_open
            >> repsep(CommonParser.identifier, SpecialCharacterParser.comma)
            << SpecialCharacterParser.angel_close
        )
        << SpecialCharacterParser.curly_open
        & opt(
            repsep(struct_property, SpecialCharacterParser.semicolon)
            << SpecialCharacterParser.semicolon
        )
        << SpecialCharacterParser.curly_close
    ) > splat(StructStatement.parse)


class DataTypeParser(ParserContext, whitespace=r"\s*"):
    data_type = fwd()

    raw_data_type = CommonParser.identifier > DataType

    parenthesized_data_type = (
        SpecialCharacterParser.parenthesis_open
        >> data_type
        << SpecialCharacterParser.parenthesis_close
    )

    intersection_data_type = (
        repsep(
            raw_data_type | parenthesized_data_type,
            SpecialCharacterParser.ampersand,
            min=2,
        )
        > IntersectionDataType
    )

    union_data_type = (
        repsep(
            raw_data_type | intersection_data_type | parenthesized_data_type,
            SpecialCharacterParser.pipe,
            min=2,
        )
        > UnionDataType
    )

    data_type.define(
        parenthesized_data_type
        | intersection_data_type
        | union_data_type
        | raw_data_type
    )
