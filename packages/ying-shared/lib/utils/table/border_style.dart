typedef CornerSymbols = ({
  String topLeft,
  String topRight,
  String bottomLeft,
  String bottomRight,
});

typedef ColumnSymbols = ({
  String top,
  String intermediate,
  String bottom,
});

typedef RowSymbols = ({
  String left,
  String right,
});

enum BorderStyle {
  single(
    corner: (
      topLeft: "┌",
      topRight: "┐",
      bottomLeft: "└",
      bottomRight: "┘",
    ),
    column: (
      top: "┬",
      intermediate: "┼",
      bottom: "┴",
    ),
    row: (
      left: "├",
      right: "┤",
    ),
    vertical: "│",
    horizontal: "─",
  ),
  double(
    corner: (
      topLeft: "╔",
      topRight: "╗",
      bottomLeft: "╚",
      bottomRight: "╝",
    ),
    column: (
      top: "╦",
      intermediate: "╬",
      bottom: "╩",
    ),
    row: (
      left: "╠",
      right: "╣",
    ),
    vertical: "║",
    horizontal: "═",
  );

  const BorderStyle({
    required this.corner,
    required this.column,
    required this.row,
    required this.vertical,
    required this.horizontal,
  });

  final CornerSymbols corner;
  final ColumnSymbols column;
  final RowSymbols row;
  final String vertical;
  final String horizontal;
}
