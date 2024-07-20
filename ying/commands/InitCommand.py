import logging
from argparse import ArgumentParser, Namespace
from os import listdir
from pathlib import Path
from typing import Optional

from ying.cli import CliCommand
from ying.shared.ProjectConfiguration import (
    DEFAULT_PROJECT_CONFIGURATION_FILE_NAME,
    ProjectConfiguration,
    ProjectType,
)


class InitCommand(CliCommand):
    def get_name(self) -> str:
        return "init"

    def get_description(self) -> Optional[str]:
        return "Initializes a new Ying project"

    def get_options_and_flag_parser(self) -> Optional[ArgumentParser]:
        parser = ArgumentParser()
        parser.add_argument("directory", type=Path, default=Path("./"))
        parser.add_argument(
            "--type",
            type=ProjectType,
            default=ProjectType.Console,
            choices=list(ProjectType),
        )
        parser.add_argument("-f", "--force", action="store_true")

        return parser

    def execute(self, parsed_arguments: Namespace) -> None:
        project_directory: Path = parsed_arguments.directory.absolute().resolve()
        is_force: bool = parsed_arguments.force

        logging.debug("Using project directory: %s", project_directory)
        logging.debug("Force creating project: %s", is_force)

        does_directory_exist = project_directory.exists()
        amount_of_files_in_directory = 0

        logging.debug("Does directory exists: %s", does_directory_exist)

        if does_directory_exist:
            amount_of_files_in_directory = len(listdir(project_directory))

        logging.debug("Amount of files in directory: %d", amount_of_files_in_directory)

        if amount_of_files_in_directory > 0 and is_force == False:
            logging.error(
                "Directory %s is not empty and the force flag is not set",
                project_directory,
            )

            return

        logging.info(
            "Creating a new %s project in directory %s",
            parsed_arguments.type,
            project_directory,
        )

        if amount_of_files_in_directory > 0 and is_force:
            logging.warning("Force creating new project in non-empty directory")

        project_type = parsed_arguments.type
        project_name = project_directory.name
        project_description = ""
        project_version = "0.0.0"
        project_license = "proprietary"

        if not is_force:
            project_name = InitCommand.get_user_input(
                f"Project Name (default: {project_directory.name}): ",
                project_name,
            )

            if project_name is None:
                return

            project_description = InitCommand.get_user_input(
                "Project description: ",
                project_description,
            )

            if project_description is None:
                return

            project_version = InitCommand.get_user_input(
                "Project version (default: 0.0.0): ",
                project_version,
            )

            if project_version is None:
                return

            project_license = InitCommand.get_user_input(
                "Project license (default: proprietary): ",
                project_license,
            )

            if project_license is None:
                return

        if not does_directory_exist:
            project_directory.mkdir(parents=True)

        configuration_file_path = (
            project_directory / DEFAULT_PROJECT_CONFIGURATION_FILE_NAME
        )

        # TODO: Define basic scripts

        project_configuration = ProjectConfiguration(
            project_type=project_type,
            name=project_name,
            description=project_description,
            version=project_version,
            license=project_license,
            entrypoint="./src/main.ya",
            scripts={},
        )

        project_configuration.write(configuration_file_path)

        main_file_contents = ""

        match project_type:
            case ProjectType.Console:
                main_file_contents = r"""import { stdout } from "package:std/system";
                
export function main(program_arguments: Array<string>): int {
    stdout.write_line("Hello world!");

    return 0;
}
"""
            case ProjectType.Library:
                main_file_contents = "export function my_function(): void {\n}\n"

        main_file_path = project_directory / "src" / "main.ya"

        if not main_file_path.exists():
            parent_directory = main_file_path.parent

            if not parent_directory.exists():
                parent_directory.mkdir(parents=True)

            main_file_path.write_text(main_file_contents, encoding="utf8")

    @staticmethod
    def get_user_input(prompt: str, default_value: str) -> Optional[str]:
        try:
            user_input = input(prompt).strip()
        except:
            return None

        if user_input == "":
            return default_value

        return user_input
