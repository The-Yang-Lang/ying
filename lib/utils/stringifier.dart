import 'dart:mirrors';

/// A class which defines static methods in order to stringify values.
///
/// These could either be primitive types (like String, int, double, num, bool)
/// or complex types like classes.
class Stringifier {
  /// Returns a string representation of the given indentation.
  static String _stringifyIndentation(int indentation) {
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
  static String _stringifyIteratable(
    Iterable<dynamic> value,
    String openingCharacter,
    String closingCharacter,
    int indentation,
  ) {
    var valueIndentation = indentation + 1;

    var joinedValues = value
        .map((entry) => stringify(entry, indentation: valueIndentation))
        .join(",\n${_stringifyIndentation(valueIndentation)}");

    var valuesString = _stringifyIndentation(valueIndentation) + joinedValues;

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
  static String stringifyInstance(dynamic instance, {int indentation = 0}) {
    var valueIndentation = indentation + 1;
    var instanceMirror = reflect(instance);
    var classMirror = instanceMirror.type;
    var className = MirrorSystem.getName(classMirror.simpleName);

    Map<String, dynamic> fields = {};

    var variableDeclarations =
        classMirror.declarations.values.whereType<VariableMirror>();

    for (var declaredValue in variableDeclarations) {
      var name = MirrorSystem.getName(declaredValue.simpleName);
      var value = instanceMirror.getField(Symbol(name));

      fields[name] = stringify(value.reflectee, indentation: indentation + 1);
    }

    var stringifiedFields = fields.entries
        .map((entry) => "${entry.key}: ${entry.value}")
        .join(",\n${_stringifyIndentation(valueIndentation)}");

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
  static String stringify(
    dynamic valueToStringify, {
    int indentation = 0,
  }) {
    if (valueToStringify is String) {
      var quotedString = valueToStringify.replaceAll('"', '\\"');

      return '"$quotedString"';
    }

    if (valueToStringify is num || valueToStringify is bool) {
      return valueToStringify.toString();
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

    if (valueToStringify is Record) {
      return valueToStringify.toString();
    }

    if (valueToStringify is Enum) {
      return valueToStringify.toString();
    }

    return stringifyInstance(valueToStringify, indentation: indentation);
  }
}
