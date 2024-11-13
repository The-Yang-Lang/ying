/// Breaks the given line into multiple lines where each line is not longer
/// than the given [maxWidth].
List<String> wrapText(String textToWrap, int maxWidth) {
  if (textToWrap.isEmpty) {
    return [];
  }

  if (textToWrap.length <= maxWidth) {
    return [textToWrap];
  }

  var result = <String>[];
  var charactersInLine = textToWrap.split('');
  var currentLine = StringBuffer();

  for (var currentCharacter in charactersInLine) {
    if (currentLine.length == 0 && currentCharacter == " ") {
      // Skip leading spaces
      continue;
    }

    // Append the current character to the current line
    currentLine.write(currentCharacter);

    if (currentLine.length < maxWidth) {
      // We still have room for more characters in the current line
      continue;
    }

    // We've reached the maximum width
    // Add the current line to the result and start a new line
    result.add(currentLine.toString());
    currentLine.clear();
  }

  if (currentLine.isNotEmpty) {
    result.add(currentLine.toString());
  }

  return result;
}
