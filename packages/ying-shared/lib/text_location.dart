import 'package:ying_shared/utils/stringify.dart';

class TextLocation {
  /// The position in the whole document
  int position = 0;

  /// The column position in the current line
  int column = 0;

  /// The line position in the current document
  int line = 1;

  TextLocation(this.position, this.column, this.line);

  /// Returns a new TextLocation with the default values
  ///
  /// This means:
  /// - the position is 0
  /// - the column is 0
  /// - the line is 1
  TextLocation.withDefaults();

  /// Advances the position and column by the given [amount]
  void advance(int amount) {
    position += amount;
    column += amount;
  }

  /// Handles a newline character and updates the position, column, and line
  ///
  /// The position and line are incremented by 1 and the column is set to 0.
  void handleNewline() {
    position++;
    line++;
    column = 0;
  }

  /// Clones the current TextLocation and returns a new TextLocation instance
  TextLocation clone() {
    return TextLocation(position, column, line);
  }

  @override
  String toString() {
    return stringifyInstance("TextLocation", fields: {
      "position": position,
      "column": column,
      "line": line,
    });
  }

  @override
  operator ==(Object other) {
    if (other is! TextLocation) {
      return false;
    }

    return position == other.position &&
        column == other.column &&
        line == other.line;
  }

  @override
  int get hashCode => Object.hash(position, column, line);
}
