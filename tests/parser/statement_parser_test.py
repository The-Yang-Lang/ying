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
    InterfaceMember,
    InterfaceStatement,
    Parameter,
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

# region parameter


def test_paramater_with_simple_data_type():
    result = StatementParser.parameter.parse("id: int")

    assert result == Success(Parameter("id", DataType("int", [])))


def test_paramater_with_complex_data_type():
    result = StatementParser.parameter.parse("id: string | int")

    assert result == Success(
        Parameter(
            "id",
            UnionDataType(
                [
                    DataType("string", []),
                    DataType("int", []),
                ]
            ),
        )
    )


# endregion

# region interface member


def test_interface_member_with_simple_data_type():
    result = StatementParser.interface_member.parse("get_id(): int")

    assert result == Success(
        InterfaceMember("get_id", [], [], DataType("int", []), False)
    )


def test_interface_member_with_complex_data_type():
    result = StatementParser.interface_member.parse("get_id(): int | string")

    assert result == Success(
        InterfaceMember(
            "get_id",
            [],
            [],
            UnionDataType(
                [
                    DataType("int", []),
                    DataType("string", []),
                ]
            ),
            False,
        )
    )


def test_interface_member_with_type_argument():
    result = StatementParser.interface_member.parse("is<T>(): bool")

    assert result == Success(
        InterfaceMember(
            "is",
            [
                TypeArgument("T", class_constraint=None, interface_constraint=None),
            ],
            [],
            DataType("bool", []),
            False,
        )
    )


def test_interface_member_with_single_parameter():
    result = StatementParser.interface_member.parse("calculate(value: int): int")

    assert result == Success(
        InterfaceMember(
            "calculate",
            [],
            [
                Parameter("value", DataType("int", [])),
            ],
            DataType("int", []),
            False,
        )
    )


def test_interface_member_with_two_parameters():
    result = StatementParser.interface_member.parse("calculate(x: int, y: int): int")

    assert result == Success(
        InterfaceMember(
            "calculate",
            [],
            [
                Parameter("x", DataType("int", [])),
                Parameter("y", DataType("int", [])),
            ],
            DataType("int", []),
            False,
        )
    )


def test_interface_member_with_two_parameters_and_trailing_comma():
    result = StatementParser.interface_member.parse("calculate(x: int, y: int,): int")

    assert result == Success(
        InterfaceMember(
            "calculate",
            [],
            [
                Parameter("x", DataType("int", [])),
                Parameter("y", DataType("int", [])),
            ],
            DataType("int", []),
            False,
        )
    )


def test_static_interface_member():
    result = StatementParser.interface_member.parse("static calculate(): int")

    assert result == Success(
        InterfaceMember(
            "calculate",
            [],
            [],
            DataType("int", []),
            True,
        )
    )


# endregion

# region interface statement


def test_empty_interface_statement():
    result = StatementParser.interface_statement.parse("interface Command {}")

    assert result == Success(
        InterfaceStatement(
            "Command",
            [],
            [],
        )
    )


def test_empty_interface_statement_with_type_arguments():
    result = StatementParser.interface_statement.parse("interface List<T> {}")

    assert result == Success(
        InterfaceStatement(
            name="List",
            type_arguments=[
                TypeArgument(
                    "T",
                    class_constraint=None,
                    interface_constraint=None,
                )
            ],
            members=[],
        )
    )


def test_interface_statement_with_members():
    result = StatementParser.interface_statement.parse(
        """interface List {
    to_string(): string;
}"""
    )

    assert result == Success(
        InterfaceStatement(
            "List",
            [],
            [
                InterfaceMember("to_string", [], [], DataType("string", []), False),
            ],
        )
    )


def test_interface_statement_with_members_and_parameters():
    result = StatementParser.interface_statement.parse(
        """interface List {
    iterator(freeze: boolean): Iterator<List>;
}"""
    )

    assert result == Success(
        InterfaceStatement(
            "List",
            [],
            [
                InterfaceMember(
                    "iterator",
                    [],
                    [
                        Parameter("freeze", DataType("boolean", [])),
                    ],
                    DataType(
                        "Iterator",
                        [
                            TypeArgument(
                                "List", class_constraint=None, interface_constraint=None
                            ),
                        ],
                    ),
                    False,
                ),
            ],
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


def test_exported_interface_statement():
    result = StatementParser.export_statement.parse("export interface Command {}")

    assert result == Success(
        ExportStatement(
            InterfaceStatement("Command", [], []),
        )
    )


# endregion
