from __future__ import annotations

from dataclasses import dataclass


@dataclass
class StringLiteral:
    value: str

    @staticmethod
    def parse(value: str) -> StringLiteral:
        return StringLiteral(value[1:-1])


@dataclass
class CharLiteral:
    value: str

    @staticmethod
    def parse(value: str) -> CharLiteral:
        return CharLiteral(value[1:-1])
