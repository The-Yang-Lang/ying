import logging
from argparse import ArgumentParser, Namespace
from platform import python_version

from ying.cli import CliCommand
from ying.shared.utils import get_ying_version


class DoctorCommand(CliCommand):
    def get_name(self) -> str:
        return "doctor"

    def get_description(self) -> str | None:
        return "Returns information about the current environment"

    def get_options_and_flag_parser(self) -> ArgumentParser | None:
        return None

    def execute(self, parsed_arguments: Namespace) -> None:
        logging.info("Using Python version: %s", python_version())
        logging.info("Using Ying version: %s", get_ying_version())
