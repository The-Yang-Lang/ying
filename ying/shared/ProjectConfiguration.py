import logging
from enum import Enum
from json import dumps
from pathlib import Path
from typing import Optional


class ProjectType(Enum):
    Console = "console"
    Library = "library"

    def __str__(self) -> str:
        return self.value


DEFAULT_PROJECT_CONFIGURATION_FILE_NAME = "yang.json"


class ProjectConfiguration:
    @staticmethod
    def create(
        path: Path,
        project_type: ProjectType,
        name: str,
        description: str,
        version: str,
        license: str,
    ):
        """Creates a new project configuration file at the specified path

        Args:
            path (Path): The path to the project configuration file
            project_type (ProjectType): The type of the new project
            name (str): The project name
            description (str): The project description
            version (str): The project version
            license (str): The project license
        """
        # TODO: Create + reference the correct JSON schema file
        # TODO: Define basic scripts

        result = {
            "name": name,
            "description": description,
            "version": version,
            "license": license,
            "type": project_type.value,
            "entrypoint": "./src/main.ya",
            "scripts": {},
        }

        if project_type != ProjectType.Console:
            del result["entrypoint"]

        json_file_contents = dumps(result, indent="\t") + "\n"

        logging.debug("Writing to file %s: %s", path, json_file_contents)

        path.write_text(json_file_contents, encoding="utf8")

    @staticmethod
    def find_in_path(path: Path) -> Optional[Path]:
        """
        Tries to find the Ying project configuration file in the given path or one of its parent directories.

        Args:
            path (Path): The starting path

        Returns:
            Optional[Path]: The found path or "None" if no directory contains the project configuration file.
        """

        for parent in path.parents:
            project_configuration_file_path = (
                parent / DEFAULT_PROJECT_CONFIGURATION_FILE_NAME
            )

            if project_configuration_file_path.exists():
                return parent

        return None
