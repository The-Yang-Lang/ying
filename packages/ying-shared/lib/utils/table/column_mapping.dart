import 'package:ying_shared/utils/table/text_alignment.dart';

/// Contains the information for mapping a column to its title and alignment
class ColumnMapping {
  /// The displayed title of the column
  final String title;

  /// The alignment of the contents of the column
  final TextAlignment alignment;

  ColumnMapping({
    required this.title,
    this.alignment = TextAlignment.left,
  });
}
