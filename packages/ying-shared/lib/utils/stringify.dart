/// Returns a string representation of the given indentation.
String _stringifyIndentation(int indentation) {
  return "    " * indentation;
}

/// Stringifies the given `Iterable<dynamic>`.
///
/// It returns a `String` which starts with the given openingCharacter, then
/// the stringified values of the iterable and ends with the given
/// closingCharacter.
///
/// The values of the `Iterable<dynamic>` are indented with the given
/// indentation + 1.
String _stringifyIteratable(
  Iterable<dynamic> value,
  String openingCharacter,
  String closingCharacter,
  int indentation,
) {
  if (value.isEmpty) {
    return "$openingCharacter$closingCharacter";
  }

  final valueIndentation = indentation + 1;

  final joinedValues = value
      .map((entry) => stringify(entry, indentation: valueIndentation))
      .join(",\n${_stringifyIndentation(valueIndentation)}");

  final valuesString = _stringifyIndentation(valueIndentation) + joinedValues;

  return "$openingCharacter\n$valuesString,\n${_stringifyIndentation(indentation)}$closingCharacter";
}

/// Stringifies the given instance using reflection and the given indentation.
///
/// It returns the name of the class + all collected properties.
///
/// NOTE: This does not include getters!
///
/// Examples:
/// - `Logger(["Main"])` -> `'Logger(\n    currentLevel: LogLevel.info,\n    nameParts: [\n        "Main",\n    ])'`
String stringifyInstance(
  String className,
  Map<String, dynamic> fields, {
  int indentation = 0,
}) {
  final valueIndentation = indentation + 1;

  final stringifiedFields = fields.entries.map((entry) {
    final key = entry.key;
    final stringifiedValue = stringify(
      entry.value,
      indentation: valueIndentation,
    );

    return "$key: $stringifiedValue";
  }).join(",\n${_stringifyIndentation(valueIndentation)}");

  if (stringifiedFields.isEmpty) {
    return "$className()";
  }

  return "$className(\n${_stringifyIndentation(valueIndentation)}$stringifiedFields\n${_stringifyIndentation(indentation)})";
}

/// Stringifies the given `dynamic` value.
///
/// It contains special cases for the following data structures:
/// - List
/// - Set
/// - MapEntry
/// - Map
/// - Record
/// - Enum
///
/// Strings will be returned in double quotes where all inner double quotes
/// are escaped.
///
/// Examples:
/// - `stringifyValue("test")` -> `"test"`
/// - `stringifyValue('"Hello world"')` -> `"\"Hello world\""`
String stringify(
  dynamic valueToStringify, {
  int indentation = 0,
}) {
  if (valueToStringify == null) {
    return "null";
  }

  if (valueToStringify is String) {
    final quotedString = valueToStringify.replaceAll('"', '\\"');

    return '"$quotedString"';
  }

  if (valueToStringify is List) {
    return _stringifyIteratable(
      valueToStringify,
      "[",
      "]",
      indentation,
    );
  }

  if (valueToStringify is Set) {
    return _stringifyIteratable(
      valueToStringify,
      "{",
      "}",
      indentation,
    );
  }

  if (valueToStringify is MapEntry) {
    return "${stringify(valueToStringify.key)}: ${stringify(valueToStringify.value, indentation: indentation + 1)}";
  }

  if (valueToStringify is Map) {
    return _stringifyIteratable(
      valueToStringify.entries,
      "{",
      "}",
      indentation,
    );
  }

  return valueToStringify.toString();
}
