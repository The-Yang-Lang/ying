from __future__ import annotations

from dataclasses import dataclass
from typing import Union

from ying.ast.data_types import (
    ComplexDataType,
    InferableDataType,
    InferDataType,
    TypeArgument,
)
from ying.ast.expression import Expression


@dataclass
class ImportedIdentifier:
    name: str


@dataclass
class ImportedAliasedIdentifier:
    name: str
    alias: str


@dataclass
class ImportStatement:
    identifiers: list[Union[ImportedIdentifier, ImportedAliasedIdentifier]]

    path: str

    @staticmethod
    def parse(imported_identifiers_list, path) -> "ImportStatement":
        imported_identifiers = []

        if len(imported_identifiers_list) > 0:
            imported_identifiers = imported_identifiers_list[0]

        return ImportStatement(imported_identifiers, path)


@dataclass
class StructProperty:
    name: str

    datatype: str


@dataclass
class StructStatement:
    name: str

    type_arguments: list[str]

    properties: list[StructProperty]

    @staticmethod
    def parse(name, type_variables, properties) -> "StructStatement":
        struct_type_variables = []

        if len(type_variables) > 0:
            struct_type_variables = type_variables[0]

        struct_properties = []

        if len(properties) > 0:
            struct_properties = properties[0]

        return StructStatement(name, struct_type_variables, struct_properties)


@dataclass
class TypeStatement:
    name: str

    data_type: ComplexDataType


@dataclass
class Parameter:
    name: str

    data_type: ComplexDataType


@dataclass
class InterfaceMember:
    name: str
    type_arguments: list[TypeArgument]
    parameters: list[Parameter]
    return_type: ComplexDataType
    is_static: bool

    @staticmethod
    def parse(
        possible_is_static: list[str],
        name: str,
        possible_type_arguments: list[list[TypeArgument]],
        possible_parameters: list[list[Parameter]],
        return_type: ComplexDataType,
    ) -> InterfaceMember:
        is_static = True if len(possible_is_static) > 0 else False
        type_arguments = []
        parameters = []

        if len(possible_type_arguments) > 0:
            type_arguments = possible_type_arguments[0]

        if len(possible_parameters) > 0:
            parameters = possible_parameters[0]

        return InterfaceMember(
            name,
            type_arguments,
            parameters,
            return_type,
            is_static,
        )


@dataclass
class InterfaceStatement:
    name: str
    type_arguments: list[TypeArgument]
    members: list[InterfaceMember]

    @staticmethod
    def parse(
        name: str,
        possible_type_arguments: list[list[TypeArgument]],
        possible_interface_members: list[list[InterfaceMember]],
    ) -> InterfaceStatement:
        type_arguments = []
        interface_members = []

        if len(possible_type_arguments) > 0:
            type_arguments = possible_type_arguments[0]

        if len(possible_interface_members) > 0:
            interface_members = possible_interface_members[0]

        return InterfaceStatement(
            name,
            type_arguments,
            interface_members,
        )


@dataclass
class ExportStatement:
    statement: Union[StructStatement, TypeStatement]


@dataclass
class VariableDeclarationStatement:
    name: str
    data_type: InferableDataType
    expression: Expression

    @staticmethod
    def parse(name, possible_data_type, expression):
        data_type = InferDataType()

        if len(possible_data_type) > 0:
            data_type = possible_data_type[0]

        return VariableDeclarationStatement(name, data_type, expression)
