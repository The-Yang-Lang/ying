/// A class which contains ANSI color codes
class AnsiColor {
  /// The actual value
  final int value;

  /// Constructs a new instance with the given value
  AnsiColor(this.value);

  /// Used for resetting the current foreground color
  static AnsiColor reset = AnsiColor(0);

  /// The ANSI color code for the red color
  static AnsiColor red = AnsiColor(31);

  /// The ANSI color code for the yellow color
  static AnsiColor yellow = AnsiColor(33);

  /// The ANSI color code for the magenta color
  static AnsiColor magenta = AnsiColor(35);

  /// The ANSI color code for the cyan color
  static AnsiColor cyan = AnsiColor(36);

  /// Returns the string representation of the ANSI color code which is used
  /// for coloring the terminal.
  @override
  String toString() {
    return "\u001b[${value}m";
  }
}
