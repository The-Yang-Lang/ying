from dataclasses import dataclass
from typing import Union


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

        print(type_variables)

        return StructStatement(name, struct_type_variables, struct_properties)
