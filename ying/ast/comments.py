from dataclasses import dataclass


@dataclass
class LineComment:
    value: str


@dataclass
class MultiLineComment:
    lines: list[str]

    def uses_multiple_lines(self):
        return len(self.lines) > 1

    @staticmethod
    def from_parser(arg: str) -> "MultiLineComment":
        return MultiLineComment([line.lstrip() for line in arg.strip().split("\n")])
