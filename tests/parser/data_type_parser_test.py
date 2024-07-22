from parsita import Success
from ying.ast.data_types import (
    DataType,
    IntersectionDataType,
    ParenthesizedDataType,
    UnionDataType,
)
from ying.parser.data_type import DataTypeParser


def test_basic_data_type():
    result = DataTypeParser.raw_data_type.parse("string")

    assert result == Success(DataType("string"))


def test_union_data_type():
    result = DataTypeParser.union_data_type.parse("string | int")

    assert result == Success(
        UnionDataType(
            [
                DataType("string"),
                DataType("int"),
            ]
        )
    )


def test_intersection_data_type():
    result = DataTypeParser.intersection_data_type.parse("string & int")

    assert result == Success(
        IntersectionDataType(
            [
                DataType("string"),
                DataType("int"),
            ]
        )
    )


def test_parenthesized_single_data_type():
    result = DataTypeParser.parenthesized_data_type.parse("(string)")

    assert result == Success(
        ParenthesizedDataType(DataType("string")),
    )


def test_parenthesized_contains_parenthesized_data_type():
    result = DataTypeParser.parenthesized_data_type.parse("((string))")

    assert result == Success(
        ParenthesizedDataType(
            ParenthesizedDataType(
                DataType("string"),
            ),
        ),
    )


def test_parenthesized_intersection_data_type():
    result = DataTypeParser.parenthesized_data_type.parse("(string & int)")

    assert result == Success(
        ParenthesizedDataType(
            IntersectionDataType(
                [
                    DataType("string"),
                    DataType("int"),
                ]
            ),
        )
    )


def test_parenthesized_union_data_type():
    result = DataTypeParser.parenthesized_data_type.parse("(string | int)")

    assert result == Success(
        ParenthesizedDataType(
            UnionDataType(
                [
                    DataType("string"),
                    DataType("int"),
                ]
            ),
        )
    )


def test_first_complex_data_type():
    result = DataTypeParser.data_type.parse("string | int & bool")

    assert result == Success(
        UnionDataType(
            [
                DataType("string"),
                IntersectionDataType(
                    [
                        DataType("int"),
                        DataType("bool"),
                    ]
                ),
            ]
        )
    )


def test_second_complex_data_type():
    result = DataTypeParser.data_type.parse(
        "string | int & bool & char | (User & Account) | float"
    )

    assert result == Success(
        UnionDataType(
            [
                DataType("string"),
                IntersectionDataType(
                    [
                        DataType("int"),
                        DataType("bool"),
                        DataType("char"),
                    ]
                ),
                ParenthesizedDataType(
                    IntersectionDataType(
                        [
                            DataType("User"),
                            DataType("Account"),
                        ]
                    ),
                ),
                DataType("float"),
            ]
        )
    )
