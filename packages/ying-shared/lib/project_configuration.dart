import 'package:ying_shared/license.dart';
import 'package:ying_shared/semantic_version.dart';

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
  Map<String, String>? scripts;

  ProjectConfiguration(this.name, this.version, this.license, this.scripts);

  /// Returns a new instance of the ProjectConfiguration based on the given name, version and license.
  ///
  /// This function is only used in the "init" command.
  ProjectConfiguration.init(this.name, this.version, this.license)
      : scripts = {"test": "ying test"};

  /// Checks if the current project configuration is valid in terms of
  /// - valid package name
  /// - valid semantic version
  /// - valid SPDX identifier / SPDX license ref
  bool isValid() {
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

  Map<String, dynamic> toJson() => {
        "name": name,
        "version": version,
        "license": license,
        "scripts": scripts,
      };
}
