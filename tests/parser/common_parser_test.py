from parsita import Success
from ying.parser.common import CommonParser

# region identifier


def test_identifier_requires_at_least_one_character():
    result = CommonParser.identifier.parse("")

    assert result.failure().expected == ["r'[a-zA-Z_][a-zA-Z0-9_]*'"]


def test_identifier_with_no_underscores():
    result = CommonParser.identifier.parse("test")

    assert result == Success("test")


def test_identifier_with_leading_underscore():
    result = CommonParser.identifier.parse("_test")

    assert result == Success("_test")


def test_identifier_with_underscores():
    result = CommonParser.identifier.parse("unit_test")

    assert result == Success("unit_test")


def test_identifier_with_trailing_single_underscore():
    result = CommonParser.identifier.parse("unit_test_")

    assert result == Success("unit_test_")


def test_identifier_with_trailing_double_underscore():
    result = CommonParser.identifier.parse("unit_test__")

    assert result == Success("unit_test__")


def test_identifier_with_integer_at_the_end():
    result = CommonParser.identifier.parse("Vector2")

    assert result == Success("Vector2")


def test_identifier_with_integer_at_the_start():
    result = CommonParser.identifier.parse("2Vector")

    assert result.failure().expected == ["r'[a-zA-Z_][a-zA-Z0-9_]*'"]


# endregion

# region string literal


def test_string_literal_with_no_escaped_character():
    result = CommonParser.string.parse('"unit test"')

    assert result == Success('"unit test"')


def test_string_literal_with_escaped_character():
    result = CommonParser.string.parse('"unit \\b test"')

    assert result == Success('"unit \\b test"')


def test_string_literal_with_escaped_quote():
    result = CommonParser.string.parse('"unit \\" test"')

    assert result == Success('"unit \\" test"')


# endregion

# region char literal


def test_char_literal_with_no_escaped_character():
    result = CommonParser.char.parse("'a'")

    assert result == Success("'a'")


def test_char_literal_with_escaped_character():
    result = CommonParser.char.parse("'\\n'")

    assert result == Success("'\\n'")


def test_char_literal_with_more_then_one_character():
    result = CommonParser.char.parse("'ab'")

    assert result.failure().expected == ["r''([a-zA-Z0-9]|\\\\[a-zA-Z])''"]


# endregion

# region boolean


def test_parse_true_as_boolean():
    result = CommonParser.boolean.parse("true")

    assert result == Success("true")


def test_parse_false_as_boolean():
    result = CommonParser.boolean.parse("false")

    assert result == Success("false")


# endregion

# region integer


def test_parse_a_whole_number_as_integer():
    result = CommonParser.integer.parse("42")

    assert result == Success("42")


def test_parse_a_whole_number_with_underscores_as_integer():
    result = CommonParser.integer.parse("1_000")

    assert result == Success("1_000")


def test_should_not_parse_a_decimal_number_as_integer():
    result = CommonParser.integer.parse("13.37")

    assert result.failure().expected == ["end of source"]


# endregion

# region float / decimal number


def test_parse_a_decimal_number_as_float():
    result = CommonParser.float.parse("13.37")

    assert result == Success("13.37")


def test_parse_a_decimal_number_with_underscores_in_the_integer_part_as_float():
    result = CommonParser.float.parse("1_000.00")

    assert result == Success("1_000.00")


def test_parse_a_decimal_number_with_underscores_in_the_fraction_part_as_float():
    result = CommonParser.float.parse("1000.0_0")

    assert result == Success("1000.0_0")


def test_should_not_parse_a_whole_number_as_float():
    result = CommonParser.float.parse("13")

    assert result.failure().expected == ["r'[0-9][0-9_]*\\.[0-9][0-9_]*'"]


# endregion

# region operators


def test_should_parse_strict_equal_operator():
    result = CommonParser.strict_equal.parse("==")

    assert result == Success("==")


def test_should_parse_strict_unequal_operator():
    result = CommonParser.strict_unequal.parse("!=")

    assert result == Success("!=")


# endregion
