import logging
from abc import ABC, abstractmethod
from argparse import Namespace
from typing import Optional, Tuple

from ying.cli.CliCommand import CliCommand


class CliApplication(ABC):
    @abstractmethod
    def get_name(self) -> str:
        """Returns the name of the application

        Returns:
            str: The name of the application
        """

    @abstractmethod
    def get_version(self) -> str:
        """Returns the version of the application

        Returns:
            str: The version of the application
        """

    @abstractmethod
    def get_description(self) -> Optional[str]:
        """Returns the optional description of the application

        Returns:
            Optional[str]: The optional description of the application
        """

    @abstractmethod
    def get_commands(self) -> list[CliCommand]:
        """Returns the commands of the application

        Returns:
            list[CliCommand]: The commands of the application
        """

    @staticmethod
    def get_command_by_args(
        commands: list[CliCommand],
        args: list[str],
    ) -> Optional[Tuple[CliCommand, Namespace]]:
        """Tries to find a command by the given arguments

        Args:
            commands (list[CliCommand]): The commands to search in
            args (list[str]): The list of arguments. The first entry will be used to find a command by its name

        Returns:
            Optional[Tuple[CliCommand, Namespace]]: The optionally found command including the parsed arguments for it
        """
        if len(args) == 0:
            return None

        if len(commands) == 0:
            return None

        for possible_command_name in args:
            for command in commands:
                if command.get_name() != possible_command_name:
                    continue

                # We have found the command
                command_arguments = args[1:]
                options_and_flag_parser = command.get_options_and_flag_parser()
                parsed_command_flags_and_options = Namespace()

                if options_and_flag_parser is not None:
                    parsed_command_flags_and_options = (
                        options_and_flag_parser.parse_args(command_arguments)
                    )

                return command, parsed_command_flags_and_options

        return None

    def run(self, arguments: list[str]):
        """Executes the application with the given arguments

        Args:
            arguments (list[str]): The arguments for the application
        """
        logging.debug(
            "Running application %s v%s with arguments: %s",
            self.get_name(),
            self.get_version(),
            arguments,
        )

        if len(arguments) == 0:
            # TODO: Print help
            return

        command_find_result = CliApplication.get_command_by_args(
            self.get_commands(),
            arguments,
        )

        if command_find_result is None:
            logging.error("Could not find command with name: %s", arguments[0])
            return

        found_command, parsed_flags_and_options = command_find_result
        found_command.execute(parsed_flags_and_options)
