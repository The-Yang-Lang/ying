from importlib.metadata import metadata


def get_ying_version() -> str:
    """Returns the current version of ying

    Returns:
        str: The current version of ying
    """
    return metadata("ying")["Version"]


def join_parser_parts(parts: list[str]) -> str:
    """Joins the given parser parts into a single string

    Args:
        parts (list[str]): The parts to join

    Returns:
        str: The joined string
    """

    return "".join(parts)
