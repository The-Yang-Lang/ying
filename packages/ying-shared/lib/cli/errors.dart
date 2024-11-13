import 'argument.dart';
import 'flag.dart';

// Arguments

class InvalidBooleanArgumentError extends Error {
  /// The argument which was tried to be parsed
  Argument argument;

  /// The value which was tried to be parsed
  String? value;

  InvalidBooleanArgumentError(this.argument, this.value);
}

class InvalidIntegerArgumentError extends Error {
  /// The argument which was tried to be parsed
  Argument argument;

  /// The value which was tried to be parsed
  String? value;

  InvalidIntegerArgumentError(this.argument, this.value);
}

class InvalidDoubleArgumentError extends Error {
  /// The argument which was tried to be parsed
  Argument argument;

  /// The value which was tried to be parsed
  String? value;

  InvalidDoubleArgumentError(this.argument, this.value);
}

class InvalidFilePathArgumentError extends Error {
  /// The argument which was tried to be parsed
  Argument argument;

  /// The value which was tried to be parsed
  String? value;

  InvalidFilePathArgumentError(this.argument, this.value);
}

class InvalidDirectoryPathArgumentError extends Error {
  /// The argument which was tried to be parsed
  Argument argument;

  /// The value which was tried to be parsed
  String? value;

  InvalidDirectoryPathArgumentError(this.argument, this.value);
}

// Flags

class InvalidBooleanFlagError extends Error {
  Flag flag;

  String? value;

  InvalidBooleanFlagError(this.flag, this.value);
}

class InvalidStringFlagError extends Error {
  Flag flag;

  String? value;

  InvalidStringFlagError(this.flag, this.value);
}

class InvalidIntegerFlagError extends Error {
  Flag flag;

  String? value;

  InvalidIntegerFlagError(this.flag, this.value);
}

class InvalidDoubleFlagError extends Error {
  Flag flag;

  String? value;

  InvalidDoubleFlagError(this.flag, this.value);
}

class InvalidFilePathFlagError extends Error {
  Flag flag;

  String? value;

  InvalidFilePathFlagError(this.flag, this.value);
}

class InvalidDirectoryPathFlagError extends Error {
  Flag flag;

  String? value;

  InvalidDirectoryPathFlagError(this.flag, this.value);
}

// General errors

class UnparsedRequiredArgumentsError extends Error {
  List<Argument> unparsedArguments;

  UnparsedRequiredArgumentsError(this.unparsedArguments);
}

class UnparsedRequiredFlagsError extends Error {
  List<Flag> unparsedFlags;

  UnparsedRequiredFlagsError(this.unparsedFlags);
}

class UnknownArgumentError extends Error {
  Argument unknownArgument;

  UnknownArgumentError(this.unknownArgument);
}

class UnknownFlagError extends Error {
  Flag unknownFlag;

  UnknownFlagError(this.unknownFlag);
}
