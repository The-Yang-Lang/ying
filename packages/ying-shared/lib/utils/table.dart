import 'dart:math' as math;

import 'package:ying_shared/utils/string.dart';
import 'package:ying_shared/utils/table/border_style.dart';
import 'package:ying_shared/utils/table/column_mapping.dart';
import 'package:ying_shared/utils/table/text_alignment.dart';

/// The data type for a row in the table
typedef Row = Map<String, String>;

/// The data type for a row in the table with wrapped text
typedef RowWithWrappedText = Map<String, List<String>>;

/// Defines the amount of border characters for each row
const amountOfBorderCharacters = 2;

/// Defines the amount of padding characters for each column
const amountOfColumnPadding = 2;

/// Generates a table for the CLI based on the given [rows]
///
/// The [mappings] define which columns of the [rows] should be included in the
/// table.
///
/// The table does not exceed the given [maximumWidth].
///
/// For now you can control the border style through the [borderStyle]
/// parameter. Right now only the `single` and `double` border style are
/// supported.
///
/// The function also takes care about removing empty columns which can be
/// controlled through the [removeEmptyColumns] parameter.
///
/// The [expandToFullWidth] parameter allows you to make the table take up the
/// full width of the given [maximumWidth].
///
/// The table will render the [emptyMessage] when the given [rows] are empty.
///
/// Optionally you can provide a custom [header] and [footer].
String generateTable({
  required Map<String, ColumnMapping> mappings,
  required List<Row> rows,
  required int maximumWidth,
  BorderStyle borderStyle = BorderStyle.single,
  bool removeEmptyColumns = false,
  bool expandToFullWidth = false,
  String emptyMessage = "No data available",
  ColumnMapping? header,
  ColumnMapping? footer,
}) {
  // Map all rows to a Map<String, String> with only the columns that are present in the mappings
  final Iterable<Row> mappedRows = rows.map((row) {
    final Row result = {};

    for (var key in mappings.keys) {
      result[key] = row[key] ?? "";
    }

    return result;
  });

  final columnHeaderRow = mappings.entries.fold<Row>({}, (acc, entry) {
    acc[entry.key] = entry.value.title;

    return acc;
  });

  final mappedRowsWithHeaders = [
    columnHeaderRow,
    ...mappedRows,
  ];

  // If we need to remove empty columns we need to update the mappings and rows
  // Otherwise we pass the original mappings and rows
  final (mappingsWithoutEmptyColumns, mappedRowsWithoutEmptyColumns) =
      removeEmptyColumns
          ? _removeEmptyColumns(mappings, mappedRowsWithHeaders)
          : (mappings, mappedRowsWithHeaders);

  if (mappingsWithoutEmptyColumns.isEmpty) {
    throw StateError(
      "No columns left after removing empty columns or empty mappings given",
    );
  }

  // Contains the amount of padding characters for each data row
  // This is the amount of columns multiplied by the amount of column padding
  // characters (usually 2 since we use 1 space for the left and 1 for the
  // right side of a column).
  final amountOfPaddingCharacters =
      mappingsWithoutEmptyColumns.length * amountOfColumnPadding;

  // Contains the amount of separator characters for each data row
  final amountOfSeparatorCharacters = mappingsWithoutEmptyColumns.length - 1;

  // Map the title of each column to its length
  final columnHeaderLengths = mappingsWithoutEmptyColumns.values.map(
    (columnMapping) => columnMapping.title.length,
  );

  // Calculate the maximum width for each column
  final rowColumnWidths =
      mappedRowsWithoutEmptyColumns.fold(columnHeaderLengths, (acc, row) {
    final newLengths = <int>[];
    final rowValues = row.values;

    for (var i = 0; i < acc.length; i++) {
      newLengths.add(math.max(acc.elementAt(i), rowValues.elementAt(i).length));
    }

    return newLengths;
  });

  // Calculate the length of the longest row in the table including the header,
  // footer and empty message.
  final longestRowLength = _calculateLongestRow(
    header?.title,
    footer?.title,
    emptyMessage,
    rowColumnWidths,
    mappedRowsWithoutEmptyColumns,
    amountOfPaddingCharacters,
    amountOfSeparatorCharacters,
  );

  final tableWidth = expandToFullWidth
      ? maximumWidth
      : math.min(longestRowLength, maximumWidth);

  final adjustedRowColumnWidths = _calculateAdjustedColumnWidths(
    rowColumnWidths,
    tableWidth,
    amountOfPaddingCharacters,
    amountOfSeparatorCharacters,
  );

  final wrappedRows = _wrapRowColumns(
    mappedRowsWithoutEmptyColumns,
    adjustedRowColumnWidths,
  );

  return _renderTable(
    borderStyle,
    emptyMessage,
    mappingsWithoutEmptyColumns.values,
    wrappedRows,
    adjustedRowColumnWidths,
    tableWidth,
    header,
    footer,
  );
}

/// Removes empty columns from the given [rows] based on the given [mappings].
(Map<String, ColumnMapping>, Iterable<Row>) _removeEmptyColumns(
  Map<String, ColumnMapping> mappings,
  Iterable<Row> rows,
) {
  // Stores a list of keys of columns that are empty in all rows
  final emptyColumns = mappings.keys.where((String key) {
    return rows.skip(1).every((row) => row[key]!.isEmpty);
  });

  // Directly return the original rows if there are no empty columns
  if (emptyColumns.isEmpty) {
    return (mappings, rows);
  }

  // Remove empty columns from the rows
  final rowsWithoutEmptyColumns = rows.map((row) {
    final Row result = {};

    for (var key in mappings.keys) {
      if (emptyColumns.contains(key)) {
        continue;
      }

      result[key] = row[key]!;
    }

    return result;
  });

  // Remove empty columns from the mappings
  final Map<String, ColumnMapping> mappingsWithoutEmptyColumns = {};

  for (var entry in mappings.entries) {
    if (emptyColumns.contains(entry.key)) {
      continue;
    }

    mappingsWithoutEmptyColumns[entry.key] = entry.value;
  }

  return (mappingsWithoutEmptyColumns, rowsWithoutEmptyColumns);
}

/// Calculates the length of the longest row in the given [rows].
/// It also includes the lengths of the header, empty message, and footer.
int _calculateLongestRow(
  String? headerText,
  String? footerText,
  String emptyMessage,
  Iterable<int> rowColumnWidths,
  Iterable<Row> rows,
  int amountOfPaddingCharacters,
  int amountOfSeparatorCharacters,
) {
  final headerLength = headerText == null
      ? 0
      : headerText.length + amountOfColumnPadding + amountOfBorderCharacters;
  final footerLength = footerText == null
      ? 0
      : footerText.length + amountOfColumnPadding + amountOfBorderCharacters;

  if (rows.length == 1) {
    // The given rows are empty so we need to return the maximum length of the
    // header, empty message, and footer

    final emptyMessageLength =
        emptyMessage.length + amountOfColumnPadding + amountOfBorderCharacters;

    return math.max(headerLength, math.max(emptyMessageLength, footerLength));
  }

  final extraLength = amountOfPaddingCharacters +
      amountOfSeparatorCharacters +
      amountOfBorderCharacters;

  final totalRowColumnsWidth = rowColumnWidths.fold(
    0,
    (acc, rowColumnWidth) => acc + rowColumnWidth,
  );

  final totalRowColumnsWidthWithExtraLength =
      totalRowColumnsWidth + extraLength;

  return math.max(
      headerLength,
      math.max(
        totalRowColumnsWidthWithExtraLength,
        footerLength,
      ));
}

/// Calculates the new column widths based on the given [tableWidth].
///
/// It returns the original [rowColumnWidths] when it has the same total length
/// as the given [tableWidth].
Iterable<int> _calculateAdjustedColumnWidths(
  Iterable<int> rowColumnWidths,
  int tableWidth,
  int amountOfPaddingCharacters,
  int amountOfSeparatorCharacters,
) {
  // Contains the total amount of row column widths
  final totalRowColumnWidths = rowColumnWidths.fold(
    0,
    (acc, width) => acc + width,
  );

  // Contains the amount of available space for the table content
  final tableContentWidth = tableWidth -
      amountOfBorderCharacters -
      amountOfPaddingCharacters -
      amountOfSeparatorCharacters;

  if (totalRowColumnWidths == tableContentWidth) {
    // The row column widths already fit into the table content width so we
    // dont need to adjust the widths
    return rowColumnWidths;
  }

  // Calculate the new column widths
  // The percentage of each column width is calculated based on the total
  // percentage of the row column widths. The new column width is then
  // calculated based on the percentage of the table content width.
  final intermediateColumnWidths = rowColumnWidths.map((columnWidth) {
    // Calculate the percentage of the column width in relation to the total
    // row column widths
    final columnWidthPercentage = 100 / totalRowColumnWidths * columnWidth;

    // Calculate the new column width based on the percentage of the table
    // content width
    final newColumnWidth = columnWidthPercentage / 100 * tableContentWidth;

    // Floor the result to the nearest integer to ensure that the column widths
    // fit into the table content width
    return newColumnWidth.floor();
  });

  final intermediateTotalColumnWidths = intermediateColumnWidths.fold(
    0,
    (acc, width) => acc + width,
  );

  if (intermediateTotalColumnWidths == tableContentWidth) {
    // The new calculated column widths fit the table content width
    return intermediateColumnWidths;
  }

  // The new calculated column widths do not fit the table content width so we
  // need to adjust the widths to fit the table content width.
  // We'll adjust the width of the column with the highest width first.

  // Calculate the difference between the table content width and the
  // intermediate total column widths
  final difference = tableContentWidth - intermediateTotalColumnWidths;

  // Find the index of the column with the highest width
  final indexWithHighestWidth = _findIndexWithHighestWidth(
    intermediateColumnWidths,
  );

  final result = <int>[];

  for (var i = 0; i < intermediateColumnWidths.length; i++) {
    final currentRowColumnWidth = intermediateColumnWidths.elementAt(i);

    if (i != indexWithHighestWidth) {
      // The current column is not the column with the highest width
      result.add(currentRowColumnWidth);

      continue;
    }

    // The current column is the column with the highest width so we need to
    // add the difference between the table content width and the intermediate
    // total column widths
    result.add(currentRowColumnWidth + difference);
  }

  return result;
}

/// Returns the index of the column with the highest width.
///
/// It returns the index of the last occurence.
///
/// Imagine the following scenario:
///
/// [rowColumnWidths] equals to [1, 2, 2, 1]
///
/// Then index 3 will be returned since it has the highest width and is the
/// last occurence.
int _findIndexWithHighestWidth(
  Iterable<int> rowColumnWidths,
) {
  var result = 0;
  var highestWidth = rowColumnWidths.elementAt(0);

  for (var i = 1; i < rowColumnWidths.length; i++) {
    final currentColumnWidth = rowColumnWidths.elementAt(i);

    if (currentColumnWidth < highestWidth) {
      continue;
    }

    result = i;
    highestWidth = currentColumnWidth;
  }

  return result;
}

/// Wraps the text content of all columns of the given [rows] based on the
/// given [columnWidths].
Iterable<RowWithWrappedText> _wrapRowColumns(
  Iterable<Row> rows,
  Iterable<int> columnWidths,
) {
  return rows.map<RowWithWrappedText>((row) {
    var result = <String, List<String>>{};
    final rowEntries = row.entries;

    for (var i = 0; i < columnWidths.length; i++) {
      final columnWidth = columnWidths.elementAt(i);
      final rowEntry = rowEntries.elementAt(i);
      final wrappedText = wrapText(rowEntry.value, columnWidth);

      result[rowEntry.key] = wrappedText;
    }

    return result;
  });
}

/// Returns the rendered table based on the given parameters.
String _renderTable(
  BorderStyle borderStyle,
  String emptyMessage,
  Iterable<ColumnMapping> columnMappings,
  Iterable<RowWithWrappedText> wrappedRows,
  Iterable<int> columnWidths,
  int tableWidth,
  ColumnMapping? header,
  ColumnMapping? footer,
) {
  final singleRowWidth = tableWidth - amountOfBorderCharacters;
  final singleRowContentWidth = singleRowWidth - amountOfColumnPadding;

  final tableColumns = wrappedRows.first.values;
  final tableContent = wrappedRows.skip(1).map((row) => row.values);
  final hasTableContent = tableContent.isNotEmpty;

  final result = StringBuffer();

  if (header != null) {
    // The top-most border line
    final topSeparatorLine =
        "${borderStyle.corner.topLeft}${borderStyle.horizontal * singleRowWidth}${borderStyle.corner.topRight}";

    // The border line between the table header and the column headers
    // The line contains the correct characters for delimiting the table columns
    final bottomSeparatorLine = _generateRowSeparatorLine(
      borderStyle,
      tableWidth,
      borderStyle.column.top,
      borderStyle.row.left,
      borderStyle.row.right,
      columnWidths,
    );

    // Write the table header to the result including the alignment, top border
    // and bottom border
    result.writeln(
      _renderSingleColumnRow(
        header.title,
        header.alignment,
        singleRowContentWidth,
        topSeparatorLine,
        bottomSeparatorLine,
        borderStyle,
      ),
    );
  } else {
    // We don't have a table header so we render the separator line directly.
    // The line contains the correct characters for delimiting the table columns
    result.writeln(
      _generateRowSeparatorLine(
        borderStyle,
        tableWidth,
        borderStyle.column.top,
        borderStyle.corner.topLeft,
        borderStyle.corner.topRight,
        columnWidths,
      ),
    );
  }

  // Write column headers
  result.writeln(_renderRow(
    borderStyle,
    tableColumns,
    columnMappings,
    columnWidths,
  ));

  // Write table content
  if (hasTableContent == false) {
    // Write the separator line between the column headers and the empty
    // message table content.
    result.writeln(
      _generateRowSeparatorLine(
        borderStyle,
        tableWidth,
        borderStyle.column.bottom,
        borderStyle.row.left,
        borderStyle.row.right,
        columnWidths,
      ),
    );

    // Write the empty message row to the result including the alignment
    result.writeln(
      _renderSingleColumnRow(
        emptyMessage,
        TextAlignment.center,
        singleRowContentWidth,
        "",
        "",
        borderStyle,
      ),
    );
  } else {
    for (var row in tableContent) {
      // Write each data row to the result including a separator line on the
      // top of each row.
      result.writeln(
        _generateRowSeparatorLine(
          borderStyle,
          tableWidth,
          borderStyle.column.intermediate,
          borderStyle.row.left,
          borderStyle.row.right,
          columnWidths,
        ),
      );

      result.writeln(_renderRow(
        borderStyle,
        row,
        columnMappings,
        columnWidths,
      ));
    }
  }

  if (footer == null) {
    // We dont have a table footer here

    if (hasTableContent) {
      // The table contains data so we need to render the correct separator
      // line which includes the correct characters for delimiting the table
      // columns
      result.writeln(
        _generateRowSeparatorLine(
          borderStyle,
          tableWidth,
          borderStyle.column.bottom,
          borderStyle.corner.bottomLeft,
          borderStyle.corner.bottomRight,
          columnWidths,
        ),
      );
    } else {
      // The table does not have any data so we render the separator line
      // without column delimiters
      result.writeln(
        _generateRowSeparatorLine(
          borderStyle,
          tableWidth,
          borderStyle.horizontal,
          borderStyle.corner.bottomLeft,
          borderStyle.corner.bottomRight,
          columnWidths,
        ),
      );
    }
  } else {
    // We have a table footer

    // Depending if the table contains data rows we need to render the
    // separator line including the column delimiters.
    // Otherwise we render the separator line without column delimiters.
    final topSeparatorLine = hasTableContent
        ? _generateRowSeparatorLine(
            borderStyle,
            tableWidth,
            borderStyle.column.bottom,
            borderStyle.row.left,
            borderStyle.row.right,
            columnWidths,
          )
        : "${borderStyle.row.left}${borderStyle.horizontal * singleRowWidth}${borderStyle.row.right}";

    final bottomSeparatorLine =
        "${borderStyle.corner.bottomLeft}${borderStyle.horizontal * singleRowWidth}${borderStyle.corner.bottomRight}";

    result.writeln(
      _renderSingleColumnRow(
        footer.title,
        footer.alignment,
        singleRowContentWidth,
        topSeparatorLine,
        bottomSeparatorLine,
        borderStyle,
      ),
    );
  }

  return result.toString().trim();
}

/// Generates the string for a row separator line.
///
/// They are used for generating the separator lines between the table
/// header + column header, between each table row and between the last table
/// row and the table footer.
String _generateRowSeparatorLine(
  BorderStyle borderStyle,
  int tableWidth,
  String separatorCharacter,
  String leftSide,
  String rightSide,
  Iterable<int> columnWidths,
) {
  var result = StringBuffer();

  result.write(leftSide);

  if (columnWidths.length == 1) {
    result.write(
      borderStyle.horizontal * (tableWidth - amountOfBorderCharacters),
    );
  } else {
    result.write(
      columnWidths
          .map(
            (width) => borderStyle.horizontal * (width + amountOfColumnPadding),
          )
          .join(separatorCharacter),
    );
  }

  result.write(rightSide);

  return result.toString();
}

/// Generates the string for the given [row]. The row could contain columns of
/// multiple lines.
///
/// The given [mappings] and [columnWidths] are needed in order to apply the
/// correct column alignment.
///
/// The given [borderStyle] is used to determine the vertical borders of the
/// line.
String _renderRow(
  BorderStyle borderStyle,
  Iterable<List<String>> row,
  Iterable<ColumnMapping> mappings,
  Iterable<int> columnWidths,
) {
  // Determine the maximum amount of lines for the given row
  final amountOfRowLines = row.fold(
    0,
    (acc, rowColumn) => math.max(acc, rowColumn.length),
  );

  final result = StringBuffer();

  for (var columnLineIndex = 0;
      columnLineIndex < amountOfRowLines;
      columnLineIndex++) {
    // Stores all parts for the current row line
    var lineToPrint = <String>[];

    for (var columnIndex = 0; columnIndex < row.length; columnIndex++) {
      // Get the current column line from the column or an empty string if not present
      final columnLine =
          row.elementAt(columnIndex).elementAtOrNull(columnLineIndex) ?? "";

      // Add the aligned text to the line to print
      lineToPrint.add(
        mappings.elementAt(columnIndex).alignment.alignString(
              columnLine,
              columnWidths.elementAt(columnIndex),
            ),
      );
    }

    // Write the line parts to the result
    result.write(borderStyle.vertical);
    result.write(
      lineToPrint.map((entry) => " $entry ").join(borderStyle.vertical),
    );
    result.writeln(borderStyle.vertical);
  }

  // We need to trim the trailing newline from the result
  return result.toString().trim();
}

/// Generates the string for a single column row.
///
/// The given [text] will be wrapped if it doesn't fit within the given
/// [contentWidth]. It will also be aligned according to the given [alignment].
///
/// The given [topSeparatorLine] and [bottomSeparatorLine] are only rendered if
/// they are not empty.
///
/// The given [borderStyle] is used to determine the vertical borders of the
/// line.
String _renderSingleColumnRow(
  String text,
  TextAlignment alignment,
  int contentWidth,
  String topSeparatorLine,
  String bottomSeparatorLine,
  BorderStyle borderStyle,
) {
  var result = StringBuffer();

  if (topSeparatorLine.isNotEmpty) {
    result.writeln(topSeparatorLine);
  }

  final textLines = wrapText(text, contentWidth);
  final alignedLines = textLines.map(
    (line) => alignment.alignString(line, contentWidth),
  );

  for (var line in alignedLines) {
    result.write(borderStyle.vertical);
    result.write(" $line ");
    result.writeln(borderStyle.vertical);
  }

  if (bottomSeparatorLine.isNotEmpty) {
    result.writeln(bottomSeparatorLine);
  }

  return result.toString().trim();
}
