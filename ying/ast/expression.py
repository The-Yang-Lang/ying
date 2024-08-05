from __future__ import annotations

from dataclasses import dataclass
from typing import Union

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


type Expression = Union[
    StringLiteral,
    CharLiteral,
    BooleanLiteral,
    IntegerLiteral,
    FloatLiteral,
    UnaryExpression,
    BinaryExpression,
]
