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


@dataclass
class BooleanLiteral:
    value: str

    def is_truthy(self) -> bool:
        """Returns True when the value is "true"

        Returns:
            bool: True when the value is "true". False otherwise.
        """

        return self.value == "true"

    def is_falsy(self) -> bool:
        """Returns False when the value is "false"

        Returns:
            bool: True when the value is "false". False otherwise.
        """

        return self.value == "false"


@dataclass
class IntegerLiteral:
    value: int

    def parse(value: str) -> IntegerLiteral:
        cleaned_value = value.replace("_", "")

        base = 10

        if value.startswith("0x"):
            base = 16
        elif value.startswith("0o"):
            base = 8

        return IntegerLiteral(int(cleaned_value, base=base))


@dataclass
class FloatLiteral:
    value: float

    def parse(value: str) -> FloatLiteral:
        cleaned_value = value.replace("_", "")

        return FloatLiteral(float(cleaned_value))
