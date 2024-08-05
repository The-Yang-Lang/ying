from parsita import ParserContext, opt, repsep
from parsita.util import splat

from ying.ast.statements import (
    ExportStatement,
    ImportedAliasedIdentifier,
    ImportedIdentifier,
    ImportStatement,
    InterfaceMember,
    InterfaceStatement,
    Parameter,
    StructProperty,
    StructStatement,
    TypeStatement,
    VariableDeclarationStatement,
)
from ying.parser.common import CommonParser
from ying.parser.data_type import DataTypeParser
from ying.parser.expression import ExpressionParser
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

    type_statement = (
        KeywordParser.kw_type
        >> CommonParser.identifier
        << SpecialCharacterParser.equal_sign
        & DataTypeParser.data_type << SpecialCharacterParser.semicolon
    ) > splat(TypeStatement)

    parameter = (
        CommonParser.identifier << SpecialCharacterParser.colon
        & DataTypeParser.data_type
        > splat(Parameter)
    )

    interface_member = (
        opt(KeywordParser.kw_static)
        & CommonParser.identifier
        & opt(
            SpecialCharacterParser.angel_open
            >> repsep(DataTypeParser.type_argument, SpecialCharacterParser.comma)
            << SpecialCharacterParser.angel_close
        )
        << SpecialCharacterParser.parenthesis_open
        & opt(
            repsep(parameter, SpecialCharacterParser.comma)
            << opt(SpecialCharacterParser.comma)
        )
        << SpecialCharacterParser.parenthesis_close
        << SpecialCharacterParser.colon
        & DataTypeParser.data_type
    ) > splat(InterfaceMember.parse)

    interface_statement = KeywordParser.kw_interface >> CommonParser.identifier & opt(
        SpecialCharacterParser.angel_open
        >> repsep(DataTypeParser.type_argument, SpecialCharacterParser.comma)
        << SpecialCharacterParser.angel_close
    ) << SpecialCharacterParser.curly_open & opt(
        repsep(interface_member, SpecialCharacterParser.semicolon)
        << SpecialCharacterParser.semicolon
    ) << SpecialCharacterParser.curly_close > splat(InterfaceStatement.parse)

    exportable_statements = struct_statement | type_statement | interface_statement

    export_statement = (
        KeywordParser.kw_export >> exportable_statements > ExportStatement
    )

    variable_declaration = (
        KeywordParser.kw_var >> CommonParser.identifier
        & opt(SpecialCharacterParser.colon >> DataTypeParser.data_type)
        << SpecialCharacterParser.equal_sign
        & (ExpressionParser.expression) << SpecialCharacterParser.semicolon
    ) > splat(VariableDeclarationStatement.parse)
