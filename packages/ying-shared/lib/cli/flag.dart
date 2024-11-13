import 'dart:io';

import 'package:path/path.dart' as path;

import 'errors.dart';

abstract class Flag<T> {
  final String name;

  final List<String> aliases;

  final String? description;

  final bool isRequired;

  Flag(this.name, this.aliases, this.isRequired, {this.description});

  T parse(String value);
}

class BoolFlag extends Flag<bool> {
  BoolFlag(super.name, super.aliases, super.isRequired, {super.description});

  @override
  bool parse(String value) {
    switch (bool.tryParse(value)) {
      case null:
        throw InvalidBooleanFlagError(this, value);
      case final parsedBoolean:
        return parsedBoolean;
    }
  }
}

class StringFlag extends Flag<String> {
  StringFlag(super.name, super.aliases, super.isRequired, {super.description});

  @override
  String parse(String value) => value;
}

class IntegerFlag extends Flag<int> {
  IntegerFlag(super.name, super.aliases, super.isRequired, {super.description});

  @override
  int parse(String value) {
    switch (int.tryParse(value)) {
      case null:
        throw InvalidIntegerFlagError(this, value);
      case final parsedInteger:
        return parsedInteger;
    }
  }
}

class DoubleFlag extends Flag<double> {
  DoubleFlag(super.name, super.aliases, super.isRequired, {super.description});

  @override
  double parse(String value) {
    switch (double.tryParse(value)) {
      case null:
        throw InvalidDoubleFlagError(this, value);
      case final parsedDouble:
        return parsedDouble;
    }
  }
}

abstract class PathFlag<T> extends Flag<T> {
  final bool mustExist;

  PathFlag(
    super.name,
    super.aliases,
    super.isRequired,
    this.mustExist, {
    super.description,
  });
}

class FileFlag extends PathFlag<File> {
  FileFlag(
    super.name,
    super.aliases,
    super.isRequired,
    super.mustExist, {
    super.description,
  });

  @override
  File parse(String value) {
    final resolvedPath = path.normalize(path.absolute(value));
    final parsedFile = File(resolvedPath);

    if (mustExist && parsedFile.existsSync() == false) {
      throw InvalidFilePathFlagError(this, value);
    }

    return parsedFile;
  }
}

class DirectoryFlag extends PathFlag<Directory> {
  DirectoryFlag(
    super.name,
    super.aliases,
    super.isRequired,
    super.mustExist, {
    super.description,
  });

  @override
  Directory parse(String value) {
    final resolvedPath = path.normalize(path.absolute(value));
    final parsedDirectory = Directory(resolvedPath);

    if (mustExist && parsedDirectory.existsSync() == false) {
      throw InvalidDirectoryPathFlagError(this, value);
    }

    return parsedDirectory;
  }
}
