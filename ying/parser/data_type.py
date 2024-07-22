from parsita import fwd, ParserContext, repsep

from ying.ast.data_types import (
    DataType,
    IntersectionDataType,
    ParenthesizedDataType,
    UnionDataType,
)
from ying.parser.common import CommonParser
from ying.parser.special_character import SpecialCharacterParser


class DataTypeParser(ParserContext, whitespace=r"\s*"):
    data_type = fwd()

    raw_data_type = CommonParser.identifier > DataType

    parenthesized_data_type = (
        SpecialCharacterParser.parenthesis_open
        >> data_type
        << SpecialCharacterParser.parenthesis_close
    ) > ParenthesizedDataType

    intersection_data_type = (
        repsep(
            raw_data_type | parenthesized_data_type,
            SpecialCharacterParser.ampersand,
            min=2,
        )
        > IntersectionDataType
    )

    union_data_type = (
        repsep(
            raw_data_type | intersection_data_type | parenthesized_data_type,
            SpecialCharacterParser.pipe,
            min=2,
        )
        > UnionDataType
    )

    data_type.define(
        parenthesized_data_type
        | intersection_data_type
        | union_data_type
        | raw_data_type
    )
