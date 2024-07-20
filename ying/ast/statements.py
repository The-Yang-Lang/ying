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
