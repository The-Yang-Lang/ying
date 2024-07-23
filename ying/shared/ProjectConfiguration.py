from __future__ import annotations

import json
import logging
from dataclasses import dataclass
from enum import Enum
from json import dumps
from pathlib import Path
from typing import Optional


class ProjectType(Enum):
    Console = "console"
    Library = "library"

    def __str__(self) -> str:
        return self.value


DEFAULT_PROJECT_CONFIGURATION_FILE_NAME = "ying.json"


@dataclass
class ProjectConfiguration:
    project_type: ProjectType
    name: str
    description: str
    version: str
    license: str
    entrypoint: str
    scripts: dict[str, str]

    def write(
        self,
        path: Path,
    ):
        """Writes the current project configuration to the given path

        Args:
            path (Path): The path to the project configuration file
        """

        # TODO: Create + reference the correct JSON schema file

        result = {
            "name": self.name,
            "description": self.description,
            "version": self.version,
            "license": self.license,
            "type": self.project_type.value,
            "entrypoint": self.entrypoint,
            "scripts": self.scripts,
        }

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

            if not project_configuration_file_path.exists():
                continue

            return parent

        return None

    @staticmethod
    def read_from_file(path: Path) -> ProjectConfiguration:
        """Tries to read the project configuration file from the given path.

        Returns:
            Optional["ProjectConfiguration"]: The read configuration or none if an error occurred.
                                              Errors could be:
                                              - the user does not have permissions to read the file
                                              - the file contains invalid JSON
                                              - the project type could not be determined
        """

        if not path.exists():
            return None

        if not path.is_file():
            return None

        try:
            raw_file_contents = path.read_text(encoding="utf8")
            parsed_file_contents = json.loads(raw_file_contents)

            return ProjectConfiguration(
                project_type=ProjectType(parsed_file_contents.type),
                name=parsed_file_contents.name,
                description=parsed_file_contents.description,
                version=parsed_file_contents.version,
                license=parsed_file_contents.license,
                entrypoint=parsed_file_contents.entrypoint,
                scripts=parsed_file_contents.scripts,
            )
        except Exception:
            return None
