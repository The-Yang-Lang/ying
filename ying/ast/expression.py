from __future__ import annotations

from dataclasses import dataclass
from typing import List, Union

from ying.ast.literals import (
    BooleanLiteral,
    CharLiteral,
    FloatLiteral,
    IntegerLiteral,
    StringLiteral,
)


@dataclass
class UnaryExpression:
    presign: str
    literal: Union[IntegerLiteral, FloatLiteral, BooleanLiteral]

    @staticmethod
    def parse(
        args,
    ) -> Union[
        IntegerLiteral,
        FloatLiteral,
        BinaryExpression,
        UnaryExpression,
        BooleanLiteral,
    ]:
        presign = ""

        if len(args[0]) == 0:
            return args[1]

        presign = args[0][0]

        return UnaryExpression(presign, args[1])


@dataclass
class BinaryExpression:
    lhs: Union[IntegerLiteral, FloatLiteral, BinaryExpression]
    operator: str
    rhs: Union[IntegerLiteral, FloatLiteral, BinaryExpression]

    @staticmethod
    def parse(args):
        expression = args[0]

        for op in args[1]:
            expression = BinaryExpression(expression, op[0], op[1])

        return expression


@dataclass
class PropertyAccessExpression:
    property_name: str


@dataclass
class ArrayAccessExpression:
    index: int


@dataclass
class NestedAccessExpression:
    base_identifier: str

    path: List[PropertyAccessExpression | ArrayAccessExpression]

    @staticmethod
    def parse(base_identifier, path_parts):
        print(f"Path: {path_parts}")

        path = []

        for path_part in path_parts:
            match path_part[0]:
                case ".":
                    path.append(PropertyAccessExpression(path_part[1]))
                case "[":
                    if isinstance(path_part[1], IntegerLiteral):
                        path.append(ArrayAccessExpression(path_part[1].value))
                    elif isinstance(path_part[1], StringLiteral):
                        path.append(PropertyAccessExpression(path_part[1].value))

        return NestedAccessExpression(
            base_identifier,
            path,
        )


type Expression = Union[
    StringLiteral,
    CharLiteral,
    BooleanLiteral,
    IntegerLiteral,
    FloatLiteral,
    UnaryExpression,
    BinaryExpression,
    NestedAccessExpression,
]
