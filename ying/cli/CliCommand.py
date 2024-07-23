import argparse
from abc import ABC, abstractmethod
from argparse import Namespace
from typing import Optional


class CliCommand(ABC):
    @abstractmethod
    def get_name(self) -> str:
        """Returns the name of the command

        Returns:
            str: The name of the command
        """

    @abstractmethod
    def get_description(self) -> Optional[str]:
        """Returns the description of the command

        Returns:
            Optional[str]: The description of the command
        """

    @abstractmethod
    def get_options_and_flag_parser(self) -> Optional[argparse.ArgumentParser]:
        """Returns the argument parser for the command which will be used to parse flags and options

        Returns:
            Optional[argparse.ArgumentParser]: The argument parser for the command
        """

    @abstractmethod
    def execute(self, parsed_arguments: Namespace) -> None:
        """Executes the command with the given command arguments

        Args:
            parsed_arguments (Namespace): The parsed command arguments from argparse
        """
