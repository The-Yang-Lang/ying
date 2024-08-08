import logging
import sys
from os import getenv
from typing import Optional

from rich.logging import RichHandler

from ying.cli import CliApplication, CliCommand
from ying.commands.DoctorCommand import DoctorCommand
from ying.commands.InitCommand import InitCommand
from ying.shared.utils import get_ying_version


class Application(CliApplication):
    def get_name(self) -> str:
        return "ying"

    def get_version(self) -> Optional[str]:
        return get_ying_version()

    def get_description(self) -> Optional[str]:
        return None

    def get_commands(self) -> list[CliCommand]:
        return [
            InitCommand(),
            DoctorCommand(),
        ]


def main():
    is_debugging = getenv("DEBUG") == "1"

    logging.basicConfig(
        level=logging.DEBUG if is_debugging else logging.INFO,
        format="%(message)s",
        datefmt="[%X]",
        handlers=[RichHandler(show_path=False)],
    )
    cleaned_program_arguments = sys.argv[1:]

    application = Application()
    application.run(cleaned_program_arguments)


if __name__ == "__main__":
    main()
