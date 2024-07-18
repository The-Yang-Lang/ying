from importlib.metadata import metadata


def get_ying_version() -> str:
    """Returns the current version of ying

    Returns:
        str: The current version of ying
    """
    return metadata("ying")["Version"]
