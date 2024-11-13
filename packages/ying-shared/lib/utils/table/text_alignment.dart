/// Defines the alignment of a column in the table
enum TextAlignment {
  left,
  center,
  right;

  /// Aligns the given [input] according to the current alignment based on the given [maxWidth]
  String alignString(String input, int maxWidth) {
    final remainingSpace = maxWidth - input.length;

    if (remainingSpace <= 0) {
      return input;
    }

    int leftPaddingAmount;
    int rightPaddingAmount;

    switch (this) {
      case TextAlignment.left:
        leftPaddingAmount = 0;
        rightPaddingAmount = remainingSpace;
        break;
      case TextAlignment.center:
        final halfRemainingSpace = remainingSpace / 2;

        leftPaddingAmount = halfRemainingSpace.floor();
        rightPaddingAmount = halfRemainingSpace.ceil();
        break;
      case TextAlignment.right:
        leftPaddingAmount = remainingSpace;
        rightPaddingAmount = 0;
        break;
    }

    final leftPadding = " " * leftPaddingAmount;
    final rightPadding = " " * rightPaddingAmount;

    return "$leftPadding$input$rightPadding";
  }
}
