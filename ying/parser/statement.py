from parsita import opt, ParserContext, repsep
from parsita.util import splat

from ying.ast.statements import (
    ImportedAliasedIdentifier,
    ImportedIdentifier,
    ImportStatement,
    StructProperty,
    StructStatement,
)
from ying.parser.common import CommonParser
from ying.parser.data_type import DataTypeParser
from ying.parser.keyword import KeywordParser
from ying.parser.special_character import SpecialCharacterParser


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
        & DataTypeParser.data_type
    ) > splat(StructProperty)

    struct_statement = (
        KeywordParser.kw_struct >> CommonParser.identifier
        & opt(
            SpecialCharacterParser.angel_open
            >> repsep(DataTypeParser.type_argument, SpecialCharacterParser.comma)
            << SpecialCharacterParser.angel_close
        )
        << SpecialCharacterParser.curly_open
        & opt(
            repsep(struct_property, SpecialCharacterParser.semicolon)
            << SpecialCharacterParser.semicolon
        )
        << SpecialCharacterParser.curly_close
    ) > splat(StructStatement.parse)
