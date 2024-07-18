import logging
import sys
from os import getenv

from rich.logging import RichHandler

from ying.cli import CliApplication
from ying.commands.DoctorCommand import DoctorCommand
from ying.commands.InitCommand import InitCommand


class Application(CliApplication):
    def get_name(self):
        return "ying"

    def get_version(self):
        return "0.0.0"

    def get_description(self):
        return None

    def get_commands(self):
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
