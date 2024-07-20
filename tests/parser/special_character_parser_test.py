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


def test_dot():
    result = SpecialCharacterParser.dot.parse(".")

    assert result == Success(".")


def test_plus():
    result = SpecialCharacterParser.plus.parse("+")

    assert result == Success("+")


def test_minus():
    result = SpecialCharacterParser.minus.parse("-")

    assert result == Success("-")


def test_asterisk():
    result = SpecialCharacterParser.asterisk.parse("*")

    assert result == Success("*")


def test_slash():
    result = SpecialCharacterParser.slash.parse("/")

    assert result == Success("/")
