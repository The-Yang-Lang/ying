from parsita import Success

from ying.ast.statements import (
    ImportedAliasedIdentifier,
    ImportedIdentifier,
    ImportStatement,
)
from ying.parser import StatementParser


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
