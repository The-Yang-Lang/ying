from parsita import Success

from ying.ast.data_types import DataType, TypeArgument
from ying.ast.statements import (
    ImportedAliasedIdentifier,
    ImportedIdentifier,
    ImportStatement,
    StructProperty,
    StructStatement,
)
from ying.parser.statement import StatementParser


def test_parse_import_statement_with_no_imported_identifiers():
    result = StatementParser.import_statement.parse(
        'import { } from "package:testing";'
    )

    assert result == Success(ImportStatement([], '"package:testing"'))


def test_parse_import_statement():
    result = StatementParser.import_statement.parse(
        'import { unit, test } from "package:testing";'
    )

    assert result == Success(
        ImportStatement(
            [
                ImportedIdentifier("unit"),
                ImportedIdentifier("test"),
            ],
            '"package:testing"',
        )
    )


def test_parse_import_statement_with_aliased_identifiers():
    result = StatementParser.import_statement.parse(
        'import { unit as Unit, test } from "package:testing";'
    )

    assert result == Success(
        ImportStatement(
            [
                ImportedAliasedIdentifier("unit", "Unit"),
                ImportedIdentifier("test"),
            ],
            '"package:testing"',
        )
    )


def test_parse_struct_property():
    result = StatementParser.struct_property.parse("username: string")

    assert result == Success(StructProperty("username", DataType("string")))


def test_parse_struct_with_no_properties():
    result = StatementParser.struct_statement.parse("struct User {\n}")

    assert result == Success(StructStatement("User", [], []))


def test_parse_struct_with_no_properties_and_one_type_argument():
    result = StatementParser.struct_statement.parse("struct User<T> {\n}")

    assert result == Success(
        StructStatement(
            "User",
            type_arguments=[
                TypeArgument(
                    name="T",
                    class_constraint=None,
                    interface_constraint=None,
                )
            ],
            properties=[],
        )
    )


def test_parse_struct_with_one_property_and_one_type_argument():
    result = StatementParser.struct_statement.parse(
        """struct User<T> {
    profile: T;
}"""
    )

    assert result == Success(
        StructStatement(
            "User",
            type_arguments=[
                TypeArgument(
                    name="T",
                    class_constraint=None,
                    interface_constraint=None,
                )
            ],
            properties=[StructProperty("profile", DataType("T"))],
        )
    )


def test_parse_struct_with_single_property():
    result = StatementParser.struct_statement.parse(
        """struct User {
    username: string;
}"""
    )

    assert result == Success(
        StructStatement(
            "User",
            [],
            [
                StructProperty("username", DataType("string")),
            ],
        )
    )


def test_parse_struct_with_multiple_properties():
    result = StatementParser.struct_statement.parse(
        """struct User {
    id: int;
    username: string;
    email: string;
}"""
    )

    assert result == Success(
        StructStatement(
            "User",
            [],
            [
                StructProperty("id", DataType("int")),
                StructProperty("username", DataType("string")),
                StructProperty("email", DataType("string")),
            ],
        )
    )
