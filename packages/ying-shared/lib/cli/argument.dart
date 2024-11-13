import 'dart:io';

import 'package:path/path.dart' as path;

import 'errors.dart';

abstract class Argument<T> {
  final String name;

  final String? description;

  final bool isRequired;

  Argument(this.name, this.isRequired, {this.description});

  T parse(String value);
}

class BoolArgument extends Argument<bool> {
  BoolArgument(super.name, super.isRequired, {super.description});

  @override
  bool parse(String value) {
    switch (bool.tryParse(value)) {
      case null:
        throw InvalidBooleanArgumentError(this, value);
      case final parsedBoolean:
        return parsedBoolean;
    }
  }
}

class StringArgument extends Argument<String> {
  StringArgument(super.name, super.isRequired, {super.description});

  @override
  String parse(String value) => value;
}

class IntegerArgument extends Argument<int> {
  IntegerArgument(super.name, super.isRequired, {super.description});

  @override
  int parse(String value) {
    switch (int.tryParse(value)) {
      case null:
        throw InvalidIntegerArgumentError(this, value);
      case final parsedInteger:
        return parsedInteger;
    }
  }
}

class DoubleArgument extends Argument<double> {
  DoubleArgument(super.name, super.isRequired, {super.description});

  @override
  double parse(String value) {
    switch (double.tryParse(value)) {
      case null:
        throw InvalidDoubleArgumentError(this, value);
      case final parsedDouble:
        return parsedDouble;
    }
  }
}

abstract class PathArgument<T> extends Argument<T> {
  final bool mustExist;

  PathArgument(
    super.name,
    super.isRequired,
    this.mustExist, {
    super.description,
  });
}

class FileArgument extends PathArgument<File> {
  FileArgument(
    super.name,
    super.isRequired,
    super.mustExist, {
    super.description,
  });

  @override
  File parse(String value) {
    final resolvedPath = path.normalize(path.absolute(value));
    final parsedFile = File(resolvedPath);

    if (mustExist && parsedFile.existsSync() == false) {
      throw InvalidFilePathArgumentError(this, value);
    }

    return parsedFile;
  }
}

class DirectoryArgument extends PathArgument<Directory> {
  DirectoryArgument(
    super.name,
    super.isRequired,
    super.mustExist, {
    super.description,
  });

  @override
  Directory parse(String value) {
    final resolvedPath = path.normalize(path.absolute(value));
    final parsedDirectory = Directory(resolvedPath);

    if (mustExist && parsedDirectory.existsSync() == false) {
      throw InvalidDirectoryPathArgumentError(this, value);
    }

    return parsedDirectory;
  }
}
