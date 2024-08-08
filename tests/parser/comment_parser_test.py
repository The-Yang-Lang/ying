from parsita import Success, rep

from ying.ast.comments import LineComment, MultiLineComment
from ying.parser.comment import CommentParser

# region line comment


def test_line_comment_without_newline():
    result = CommentParser.line_comment.parse("// unit test")

    assert result == Success(LineComment("// unit test"))


def test_line_comment_with_newline():
    result = CommentParser.line_comment.parse("\n// unit test\n")

    assert result == Success(LineComment("// unit test"))


# endregion

# region multi line comment


def test_multi_line_comment_on_single_line():
    result = CommentParser.multi_line_comment.parse("/* unit test */")

    assert result == Success(MultiLineComment(["/* unit test */"]))
    assert not result.unwrap().uses_multiple_lines()


def test_multi_line_comment_on_multi_line_without_asterisks():
    result = CommentParser.multi_line_comment.parse(
        """/*
   unit test
 */
"""
    )

    assert result == Success(MultiLineComment(["/*", "unit test", "*/"]))
    assert result.unwrap().uses_multiple_lines()


def test_multi_line_comment_on_multi_line_with_asterisks():
    result = CommentParser.multi_line_comment.parse(
        """/*
 * unit test
 */
"""
    )

    assert result == Success(MultiLineComment(["/*", "* unit test", "*/"]))


# endregion


# region documentation comment


def test_documentation_comment():
    result = CommentParser.documentation_comment.parse("/** hello world */")

    assert result == Success(MultiLineComment(["/** hello world */"]))


# endregion


def test_comment_with_line_comment_and_multi_line_comment():
    result = rep(CommentParser.line_comment | CommentParser.multi_line_comment).parse(
        """// unit test

/*
 * unit test
 */
"""
    )

    assert result == Success(
        [
            LineComment("// unit test"),
            MultiLineComment(["/*", "* unit test", "*/"]),
        ]
    )


def test_comment_with_multi_line_comment_and_line_comment():
    result = rep(CommentParser.line_comment | CommentParser.multi_line_comment).parse(
        """/*
 * unit test
 */

// unit test
"""
    )

    assert result == Success(
        [
            MultiLineComment(["/*", "* unit test", "*/"]),
            LineComment("// unit test"),
        ]
    )
