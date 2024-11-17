import 'dart:convert' show JsonUnsupportedObjectError;

import 'package:ying_shared/license.dart' show isValidSpdxLicense;
import 'package:ying_shared/semantic_version.dart' show parseSemanticVersion;

/// The regex for validating short package names
final shortNameRegex = RegExp(r'^[a-zA-Z](-?[a-zA-Z0-9])*$');

/// The regex for validating long package names
///
/// Those which have a scope prepended
final longNameRegex = RegExp(
  r'^@[a-zA-Z](-?[a-zA-Z0-9])*\/[a-zA-Z-]((_|-)?[a-zA-Z0-9])*$',
);

/// Validates if the given [input] is a short package name or long package name.
///
/// Returns false when the input is neither a short package name nor a long package name.
///
/// Examples for short package names:
/// - my-test
/// - MY-TEST
///
/// Examples for long package names:
/// - @me/my-package
/// - @me123/my-package
/// - @my-awesome-org/my-package
/// - @MY-AWESOME-ORG/MY-PACKAGE123
bool validatePackageName(String input) {
  if (shortNameRegex.hasMatch(input)) {
    return true;
  }

  if (longNameRegex.hasMatch(input)) {
    return true;
  }

  return false;
}

class ProjectConfiguration {
  String name;
  String version;
  String license;
  Map<String, String> scripts;
  Map<String, String> dependencies;
  Map<String, String> developmentDependencies;

  ProjectConfiguration(
    this.name,
    this.version,
    this.license,
    this.scripts,
    this.dependencies,
    this.developmentDependencies,
  );

  /// Returns a new instance of the ProjectConfiguration based on the given name, version and license.
  ///
  /// This function is only used in the "init" command.
  ProjectConfiguration.init(this.name, this.version, this.license)
      : scripts = {
          "test": "ying test",
        },
        dependencies = {},
        developmentDependencies = {};

  /// Checks if the current project configuration is valid in terms of
  /// - valid package name
  /// - valid semantic version
  /// - valid SPDX identifier / SPDX license ref
  bool validate() {
    if (validatePackageName(name) == false) {
      return false;
    }

    if (parseSemanticVersion(version) == null) {
      return false;
    }

    if (isValidSpdxLicense(license) == false) {
      return false;
    }

    return true;
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{
      "name": name,
      "version": version,
      "license": license,
    };

    if (scripts.isNotEmpty) {
      result["scripts"] = scripts;
    }

    if (dependencies.isNotEmpty) {
      result["dependencies"] = dependencies;
    }

    if (developmentDependencies.isNotEmpty) {
      result["developmentDependencies"] = developmentDependencies;
    }

    return result;
  }

  static ProjectConfiguration fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw JsonUnsupportedObjectError(json, cause: "not a map");
    }

    final name = json["name"];

    if (name is! String) {
      throw JsonUnsupportedObjectError(json["name"], cause: "not a string");
    }

    final version = json["version"];

    if (version is! String) {
      throw JsonUnsupportedObjectError(json["version"], cause: "not a string");
    }

    final license = json["license"];

    if (license is! String) {
      throw JsonUnsupportedObjectError(json["license"], cause: "not a string");
    }

    final scripts = json["scripts"] ?? <String, String>{};

    if (scripts is! Map<String, String>) {
      throw JsonUnsupportedObjectError(json["scripts"], cause: "not a map");
    }

    final dependencies = json["dependencies"] ?? <String, String>{};

    if (dependencies is! Map<String, String>) {
      throw JsonUnsupportedObjectError(
        json["dependencies"],
        cause: "not a map",
      );
    }

    final developmentDependencies =
        json["developmentDependencies"] ?? <String, String>{};

    if (developmentDependencies is! Map<String, String>) {
      throw JsonUnsupportedObjectError(
        json["developmentDependencies"],
        cause: "not a map",
      );
    }

    return ProjectConfiguration(
      name,
      version,
      license,
      scripts,
      dependencies,
      developmentDependencies,
    );
  }
}
