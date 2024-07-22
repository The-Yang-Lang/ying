from __future__ import annotations

from dataclasses import dataclass
from typing import Optional, Union


@dataclass
class DataType:
    name: str

    type_arguments: list[TypeArgument]

    @staticmethod
    def parse(name, possible_type_arguments) -> DataType:
        type_arguments = []

        if len(possible_type_arguments) > 0:
            type_arguments = possible_type_arguments[0]

        return DataType(name, type_arguments)


@dataclass
class UnionDataType:
    types: list[
        Union[DataType, UnionDataType, IntersectionDataType, ParenthesizedDataType]
    ]


@dataclass
class IntersectionDataType:
    types: list[
        Union[DataType, UnionDataType, IntersectionDataType, ParenthesizedDataType]
    ]


@dataclass
class ParenthesizedDataType:
    inner_value: Union[
        DataType, UnionDataType, IntersectionDataType, ParenthesizedDataType
    ]


@dataclass
class TypeArgument:
    name: str

    class_constraint: Optional[DataType]

    interface_constraint: Optional[
        Union[
            DataType,
            UnionDataType,
            IntersectionDataType,
            ParenthesizedDataType,
        ]
    ]

    def parse(
        name: str,
        possible_class_constraint: Optional[DataType],
        possible_interface_constraint: Optional[
            Union[
                DataType,
                UnionDataType,
                IntersectionDataType,
                ParenthesizedDataType,
            ]
        ],
    ) -> TypeArgument:
        class_constraint = None
        interface_constraint = None

        if len(possible_class_constraint) > 0:
            class_constraint = possible_class_constraint[0]

        if len(possible_interface_constraint) > 0:
            interface_constraint = possible_interface_constraint[0]

        return TypeArgument(name, class_constraint, interface_constraint)
