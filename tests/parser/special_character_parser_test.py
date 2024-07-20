from parsita import Success
from ying.parser import SpecialCharacterParser


def test_parenthesis_open():
    result = SpecialCharacterParser.parenthesis_open.parse("(")

    assert result == Success("(")


def test_parenthesis_close():
    result = SpecialCharacterParser.parenthesis_close.parse(")")

    assert result == Success(")")


def test_curly_open():
    result = SpecialCharacterParser.curly_open.parse("{")

    assert result == Success("{")


def test_curly_close():
    result = SpecialCharacterParser.curly_close.parse("}")

    assert result == Success("}")


def test_angel_open():
    result = SpecialCharacterParser.angel_open.parse("<")

    assert result == Success("<")


def test_angel_close():
    result = SpecialCharacterParser.angel_close.parse(">")

    assert result == Success(">")
