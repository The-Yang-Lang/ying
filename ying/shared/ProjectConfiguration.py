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

        json_file_contents = dumps(result, indent="\t")

        path.write_text(json_file_contents + "\n", encoding="utf8")

    @staticmethod
    def find_in_path(path: Path) -> Optional[Path]:
        for parent in path.parents:
            project_configuration_file_path = (
                parent / DEFAULT_PROJECT_CONFIGURATION_FILE_NAME
            )

            if project_configuration_file_path.exists():
                return parent

        return None
