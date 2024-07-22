from parsita import fwd, opt, ParserContext, repsep
from parsita.util import splat

from ying.ast.data_types import (
    DataType,
    IntersectionDataType,
    ParenthesizedDataType,
    TypeArgument,
    UnionDataType,
)
from ying.parser.common import CommonParser
from ying.parser.keyword import KeywordParser
from ying.parser.special_character import SpecialCharacterParser


class DataTypeParser(ParserContext, whitespace=r"\s*"):
    type_argument = fwd()
    data_type = fwd()

    raw_data_type = CommonParser.identifier & opt(
        SpecialCharacterParser.angel_open
        >> repsep(type_argument, SpecialCharacterParser.comma)
        << SpecialCharacterParser.angel_close
    ) > splat(DataType.parse)

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

    type_argument.define(
        (
            CommonParser.identifier
            & opt(KeywordParser.kw_extends >> raw_data_type)
            & opt(KeywordParser.kw_implements >> data_type)
        )
        > splat(TypeArgument.parse)
    )
