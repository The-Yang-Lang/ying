import 'dart:io';

import 'package:ying_shared/logging/ansi_color.dart';
import 'package:ying_shared/logging/log_level.dart';
import 'package:ying_shared/utils/stringify.dart';

class Logger {
  /// The current `LogLevel` of the logger.
  ///
  /// Any levels above the index of the level will not be printed.
  LogLevel currentLevel;

  /// The name parts of the logger.
  ///
  /// These are joined togeather when printing a message.
  ///
  /// Example:
  /// - `["Unit", "Test"]` -> `"[Unit] [Test]"`
  List<String> nameParts;

  /// The mapping for each `LogLevel` to an `AnsiColor`
  final Map<LogLevel, AnsiColor> _levelColors = {
    LogLevel.error: AnsiColor.red,
    LogLevel.warn: AnsiColor.yellow,
    LogLevel.info: AnsiColor.reset,
    LogLevel.debug: AnsiColor.cyan,
    LogLevel.trace: AnsiColor.magenta,
  };

  /// Instantiates a new `Logger` based on the given name parts and `LogLevel`.
  Logger(this.nameParts, this.currentLevel);

  /// Instantiates a new `Logger` with the given name.
  ///
  /// The current `LogLevel` is determined by the `getLogLevelFromEnvironment`
  /// function.
  Logger.withSimpleName(String name, this.currentLevel) : nameParts = [name];

  /// Instantiates a new `Logger` with the given name where the `LogLevel` is
  /// determined by the `getLogLevelFromEnvironment` function.
  Logger.withSimpleNameFromEnv(String name)
      : nameParts = [name],
        currentLevel = getLogLevelFromEnvironment(null);

  /// Logs the given message with `LogLevel.error` as level
  void error(String message) => _log(LogLevel.error, message);

  /// Logs the given message with `LogLevel.warn` as level
  void warn(String message) => _log(LogLevel.warn, message);

  /// Logs the given message with `LogLevel.info` as level
  void info(String message) => _log(LogLevel.info, message);

  /// Logs the given message with `LogLevel.debug` as level
  void debug(String message) => _log(LogLevel.debug, message);

  /// Logs the given message with `LogLevel.trace` as level
  void trace(String message) => _log(LogLevel.trace, message);

  /// Returns a new `Logger` instance where the given name is appended to the
  /// name parts of the current instance.
  ///
  /// You can optionally pass a new `LogLevel` in order to overwrite it.
  ///
  /// Otherwise it uses the `LogLevel` of the current instance.
  Logger extend(String name, {LogLevel? newLevel}) {
    return Logger([...nameParts, name], newLevel ?? currentLevel);
  }

  /// Returns a `String` representation of the current instance
  @override
  String toString() => stringifyInstance("Logger", {
        "currentLevel": currentLevel,
        "nameParts": nameParts,
      });

  /// The utility method for printing log messages.
  void _log(LogLevel level, String message) {
    if (level.index > currentLevel.index) {
      return;
    }

    var color = _levelColors[level];
    var reset = AnsiColor.reset;

    var timestamp = _getFormattedTimestamp();
    var joinedNameParts = nameParts.map((entry) => "[$entry]").join(" ");

    if (Platform.isLinux || Platform.isMacOS) {
      print(
        "$color$timestamp [${level.name.toUpperCase().padRight(levelPadding)}] $joinedNameParts $message$reset",
      );
    } else {
      print(
        "$timestamp [${level.name.toUpperCase().padRight(levelPadding)}] $joinedNameParts $message",
      );
    }
  }

  /// Returns the formatted timestamp
  String _getFormattedTimestamp() {
    var timestamp = DateTime.now();

    var date = [
      _padNumber(timestamp.day),
      _padNumber(timestamp.month),
      _padNumber(timestamp.year, width: 4),
    ].join(".");

    var time =
        "${_padNumber(timestamp.hour)}:${_padNumber(timestamp.minute)}:${_padNumber(timestamp.second)}.${_padNumber(timestamp.millisecond)}";

    return "[$date] [$time]";
  }

  /// Pads the given number on the left side with zeros (0) to the given width.
  ///
  /// This function is only used in the `_getFormattedTimestamp` function.
  String _padNumber(num input, {int width = 2}) {
    return input.toString().padLeft(width, '0');
  }
}
