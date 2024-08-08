from argparse import ArgumentParser, Namespace

from ying.cli import CliApplication, CliCommand


class FirstCommand(CliCommand):
    def get_name(self) -> str:
        return "first"

    def get_description(self) -> str | None:
        pass

    def get_options_and_flag_parser(self) -> ArgumentParser | None:
        return None

    def execute(self, parsed_arguments: Namespace) -> None:
        pass


class SecondCommand(CliCommand):
    def get_name(self) -> str:
        return "second"

    def get_description(self) -> str | None:
        pass

    def get_options_and_flag_parser(self) -> ArgumentParser | None:
        parser = ArgumentParser()
        parser.add_argument("-f", "--force", action="store_true")

        return parser

    def execute(self, parsed_arguments: Namespace) -> None:
        pass


# region get_command_by_args


def test_get_command_by_args_with_empty_args():
    result = CliApplication.get_command_by_args([FirstCommand(), SecondCommand()], [])

    assert result is None


def test_get_command_by_args_with_empty_commands():
    result = CliApplication.get_command_by_args([], ["first"])

    assert result is None


def test_get_command_by_args_returns_none_when_no_command_matches():
    result = CliApplication.get_command_by_args(
        [
            FirstCommand(),
            SecondCommand(),
        ],
        ["test"],
    )

    assert result is None


def test_get_command_by_args_returns_should_return_the_correct_command():
    command_to_find = SecondCommand()

    result = CliApplication.get_command_by_args(
        [
            FirstCommand(),
            command_to_find,
        ],
        ["second"],
    )

    assert result == (command_to_find, Namespace(force=False))


def test_get_command_by_args_returns_should_return_the_correct_command_and_parsed_arguments():
    command_to_find = SecondCommand()

    result = CliApplication.get_command_by_args(
        [
            FirstCommand(),
            command_to_find,
        ],
        ["second", "-f"],
    )

    assert result == (command_to_find, Namespace(force=True))


# endregion
