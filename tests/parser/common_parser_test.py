from parsita import Success
from ying.parser import CommonParser


def test_variable_identifier_with_no_underscores():
    result = CommonParser.identifier.parse("test")

    assert result == Success("test")


def test_variable_identifier_with_leading_underscore():
    result = CommonParser.identifier.parse("_test")

    assert result == Success("_test")


def test_variable_identifier_with_underscores():
    result = CommonParser.identifier.parse("unit_test")

    assert result == Success("unit_test")


def test_variable_identifier_with_trailing_single_underscore():
    result = CommonParser.identifier.parse("unit_test_")

    assert result == Success("unit_test_")


def test_variable_identifier_with_trailing_double_underscore():
    result = CommonParser.identifier.parse("unit_test__")

    assert result == Success("unit_test__")


def test_string_literal_with_no_escaped_character():
    result = CommonParser.string.parse('"unit test"')

    assert result == Success('"unit test"')


def test_string_literal_with_escaped_character():
    result = CommonParser.string.parse('"unit \\b test"')

    assert result == Success('"unit \\b test"')


def test_string_literal_with_escaped_quote():
    result = CommonParser.string.parse('"unit \\" test"')

    assert result == Success('"unit \\" test"')


def test_char_literal_with_no_escaped_character():
    result = CommonParser.char.parse("'a'")

    assert result == Success("'a'")


def test_char_literal_with_escaped_character():
    result = CommonParser.char.parse("'\\n'")

    assert result == Success("'\\n'")


def test_char_literal_with_more_then_one_character():
    result = CommonParser.char.parse("'ab'")

    assert result.failure().expected == ["r''([a-zA-Z0-9]|\\\\[a-zA-Z])''"]


def test_parse_true_as_boolean():
    result = CommonParser.boolean.parse("true")

    assert result == Success("true")


def test_parse_false_as_boolean():
    result = CommonParser.boolean.parse("false")

    assert result == Success("false")
