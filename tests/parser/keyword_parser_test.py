from parsita import Success
from ying.parser import KeywordParser


def test_import_keyword():
    result = KeywordParser.kw_import.parse("import")

    assert result == Success("import")


def test_from_keyword():
    result = KeywordParser.kw_from.parse("from")

    assert result == Success("from")


def test_export_keyword():
    result = KeywordParser.kw_export.parse("export")

    assert result == Success("export")


def test_struct_keyword():
    result = KeywordParser.kw_struct.parse("struct")

    assert result == Success("struct")


def test_class_keyword():
    result = KeywordParser.kw_class.parse("class")

    assert result == Success("class")
