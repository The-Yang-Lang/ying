from __future__ import annotations

from dataclasses import dataclass
from typing import Union


@dataclass
class DataType:
    name: str


@dataclass
class UnionDataType:
    types: list[Union[DataType, UnionDataType, IntersectionDataType]]


@dataclass
class IntersectionDataType:
    types: list[Union[DataType, UnionDataType, IntersectionDataType]]
