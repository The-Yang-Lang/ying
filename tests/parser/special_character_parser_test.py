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


def test_percent():
    result = SpecialCharacterParser.percent.parse("%")

    assert result == Success("%")


def test_colon():
    result = SpecialCharacterParser.colon.parse(":")

    assert result == Success(":")


def test_semicolon():
    result = SpecialCharacterParser.semicolon.parse(";")

    assert result == Success(";")


def test_comma():
    result = SpecialCharacterParser.comma.parse(",")

    assert result == Success(",")


def test_equal_sign():
    result = SpecialCharacterParser.equal_sign.parse("=")

    assert result == Success("=")


def test_question_mark():
    result = SpecialCharacterParser.question_mark.parse("?")

    assert result == Success("?")


def test_exclamation_mark():
    result = SpecialCharacterParser.exclamation_mark.parse("!")

    assert result == Success("!")


def test_ampersand():
    result = SpecialCharacterParser.ampersand.parse("&")

    assert result == Success("&")


def test_pipe():
    result = SpecialCharacterParser.pipe.parse("|")

    assert result == Success("|")
