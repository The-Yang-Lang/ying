import 'dart:io';
import 'dart:math';

/// Defines all possible log levels
enum LogLevel {
  error,
  warn,
  info,
  debug,
  trace;
}

/// Contains the longest string length of all `LogLevel`s
final int levelPadding = LogLevel.values
    .map((entry) => entry.name)
    .fold(0, (acc, entry) => max(acc, entry.length));

/// Returns the `LogLevel` based on the environment variables.
///
/// It lowercases + trims the current value before matching it.
///
/// It returns `LogLevel.info` when no matching LogLevel was found or the
/// environment is not set.
///
/// When a `Map<String, String>` instead of null is passed to the function then
/// this value will be used for the lookup.
LogLevel getLogLevelFromEnvironment(Map<String, String>? environmentVariables) {
  var mapToWorkWith = environmentVariables ?? Platform.environment;

  switch (mapToWorkWith["LOG_LEVEL"]?.toLowerCase().trim()) {
    case "trace":
      return LogLevel.trace;

    case "debug":
      return LogLevel.debug;

    case "info":
      return LogLevel.info;

    case "warn":
      return LogLevel.warn;

    case "error":
      return LogLevel.error;

    default:
      return LogLevel.info;
  }
}
