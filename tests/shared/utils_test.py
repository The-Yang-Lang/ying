from ying.shared.utils import get_ying_version, join_parser_parts


def test_get_ying_version():
    result = get_ying_version()

    assert isinstance(result, str)


def test_join_parser_parts_with_empty_list():
    result = join_parser_parts([])

    assert result == ""


def test_join_parser_parts_with_single_entry_in_list():
    result = join_parser_parts(["unit"])

    assert result == "unit"


def test_join_parser_parts_with_two_entries_in_list():
    result = join_parser_parts(["unit", "test"])

    assert result == "unittest"
