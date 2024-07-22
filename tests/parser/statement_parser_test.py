from parsita import Success

from ying.ast.data_types import (
    DataType,
    IntersectionDataType,
    TypeArgument,
    UnionDataType,
)
from ying.ast.statements import (
    ExportStatement,
    ImportedAliasedIdentifier,
    ImportedIdentifier,
    ImportStatement,
    StructProperty,
    StructStatement,
    TypeStatement,
)
from ying.parser.statement import StatementParser

# region import statement


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


# endregion

# region structs


def test_parse_struct_property():
    result = StatementParser.struct_property.parse("username: string")

    assert result == Success(StructProperty("username", DataType("string", [])))


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
            properties=[StructProperty("profile", DataType("T", []))],
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
                StructProperty("username", DataType("string", [])),
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
                StructProperty("id", DataType("int", [])),
                StructProperty("username", DataType("string", [])),
                StructProperty("email", DataType("string", [])),
            ],
        )
    )


# endregion

# region type statement


def test_type_statement_with_simple_data_type():
    result = StatementParser.type_statement.parse("type Id = int;")

    assert result == Success(
        TypeStatement(
            "Id",
            DataType("int", []),
        )
    )


def test_type_statement_with_intersection_data_type():
    result = StatementParser.type_statement.parse("type Id = string & int;")

    assert result == Success(
        TypeStatement(
            "Id",
            IntersectionDataType(
                [
                    DataType("string", []),
                    DataType("int", []),
                ]
            ),
        )
    )


def test_type_statement_with_union_data_type():
    result = StatementParser.type_statement.parse("type Id = string | int;")

    assert result == Success(
        TypeStatement(
            "Id",
            UnionDataType(
                [
                    DataType("string", []),
                    DataType("int", []),
                ]
            ),
        )
    )


# endregion

# region export statement


def test_exported_struct_statement():
    result = StatementParser.export_statement.parse("export struct User {}")

    assert result == Success(
        ExportStatement(
            StructStatement("User", type_arguments=[], properties=[]),
        )
    )


def test_exported_type_statement():
    result = StatementParser.export_statement.parse("export type Id = string;")

    assert result == Success(
        ExportStatement(
            TypeStatement("Id", DataType("string", [])),
        )
    )


# endregion
