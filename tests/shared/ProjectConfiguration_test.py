import pytest

from ying.shared.ProjectConfiguration import ProjectConfiguration, ProjectType


@pytest.fixture()
def example_configuration():
    return ProjectConfiguration(
        project_type=ProjectType.Console,
        name="Unit Test",
        description="",
        version="0.0.0",
        license="MIT",
        entrypoint="./src/main.ya",
        scripts={},
    )


# region ProjectType


def test_stringify_console_project_type():
    assert str(ProjectType.Console) == "console"


def test_stringify_library_project_type():
    assert str(ProjectType.Library) == "library"


# endregion

# region write


def test_write_project_configuration_file_when_the_file_does_not_exists(
    tmp_path, example_configuration
):
    file_path = tmp_path / "ying.json"

    example_configuration.write(file_path)

    assert file_path.exists()


def test_write_project_configuration_file_when_the_file_exists(
    tmp_path, example_configuration
):
    file_path = tmp_path / "ying.json"

    file_path.touch()

    assert file_path.exists()

    example_configuration.write(file_path)

    assert file_path.exists()


# endregion

# region find_in_path


def test_find_in_path_returns_none_when_no_configuration_file_was_found(tmp_path):
    assert ProjectConfiguration.find_in_path(tmp_path) is None


def test_find_in_path_returns_the_file_path_when_a_configuration_file_was_found(
    tmp_path,
    example_configuration,
):
    file_path = tmp_path / "ying.json"

    example_configuration.write(file_path)

    assert ProjectConfiguration.find_in_path(tmp_path) == file_path


def test_find_in_path_returns_the_correct_file_path_when_a_configuration_file_was_found_in_the_parent_directory(
    tmp_path,
    example_configuration,
):
    file_path = tmp_path.parent / "ying.json"

    example_configuration.write(file_path)

    assert ProjectConfiguration.find_in_path(tmp_path) == file_path


# endregion

# region read_from_file


def test_read_from_file_should_return_none_when_the_file_does_not_exists(tmp_path):
    result = ProjectConfiguration.read_from_file(tmp_path / "does_not_exists.json")

    assert not result


def test_read_from_file_should_return_none_when_the_given_path_is_a_directory(tmp_path):
    result = ProjectConfiguration.read_from_file(tmp_path)

    assert not result


def test_read_from_file_should_return_none_when_the_file_contains_invalid_json(
    tmp_path,
):
    file_path = tmp_path.parent / "ying.json"
    file_path.write_text("unit test")

    result = ProjectConfiguration.read_from_file(file_path)

    assert not result


def test_read_from_file_should_return_a_valid_project_configuration(
    tmp_path, example_configuration
):
    file_path = tmp_path.parent / "ying.json"
    example_configuration.write(file_path)

    read_project_configuration = ProjectConfiguration.read_from_file(file_path)

    assert read_project_configuration == example_configuration


# endregion
