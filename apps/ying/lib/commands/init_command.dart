import 'dart:io';

import 'package:path/path.dart';
import 'package:ying_shared/cli/argument.dart';
import 'package:ying_shared/cli/command.dart';
import 'package:ying_shared/cli/command_execution_context.dart';
import 'package:ying_shared/cli/flag.dart';
import 'package:ying_shared/license.dart';
import 'package:ying_shared/logging/logger.dart';
import 'package:ying_shared/project.dart';
import 'package:ying_shared/project_configuration.dart';
import 'package:ying_shared/semantic_version.dart';

class InitCommand extends Command {
  final Logger logger = Logger.withSimpleNameFromEnv("init");

  InitCommand()
      : super(
          "init",
          [],
          [
            DirectoryArgument(
              "directory",
              true,
              false,
              description:
                  "The directory where the new project will be initialized in",
            ),
          ],
          [
            StringFlag(
              "name",
              [],
              false,
              description: "The name of the package to create",
            ),
            StringFlag(
              "version",
              [],
              false,
              description: "The version of the package to create",
            ),
            StringFlag(
              "license",
              [],
              false,
              description: "The license of the package to create",
            ),
          ],
          description: "Initializes a new Ying project",
        );

  @override
  void execute(CommandExecutionContext commandExecutionContext) {
    logger.debug("Running the init command: $commandExecutionContext");

    Directory packageDirectory =
        commandExecutionContext.parsedArguments["directory"];

    var packageName = commandExecutionContext.parsedFlags["name"];
    var packageVersion = commandExecutionContext.parsedFlags["version"];
    var packageLicense = commandExecutionContext.parsedFlags["license"];

    if (packageName == null) {
      packageName = _readPackageName(packageDirectory);
    } else if (validatePackageName(packageName) == false) {
      logger.warn("The provided package name via the flag is not valid");

      packageName = _readPackageName(packageDirectory);
    }

    if (packageVersion == null) {
      packageVersion = _readPackageVersion();
    } else if (parseSemanticVersion(packageVersion) == null) {
      logger.warn(
        "The provided package version via the flag is not a valid semantic version",
      );

      packageVersion = _readPackageVersion();
    }

    if (packageLicense == null) {
      packageLicense = _readPackageLicense();
    } else if (isValidSpdxLicense(packageLicense) == false) {
      logger.warn(
        "The provided package license via the flag is not a valid SPDX identifier",
      );

      packageLicense = _readPackageLicense();
    }

    final projectConfiguration = ProjectConfiguration.init(
      packageName,
      packageVersion.toString(),
      packageLicense,
    );

    try {
      initializeProject(packageDirectory, projectConfiguration);
    } on FileSystemException catch (e) {
      logger.error(
        "Could not initialize project in directory '${packageDirectory.path}': ${e.message}",
      );

      return;
    }

    logger.info("Successfully created project in ${packageDirectory.path}");
  }

  /// Reads user input from the attached process input.
  /// Before reading it is printing the given [prompt].
  ///
  /// When [allowEmptyInput] is true then the user is allowed to not provide any answer.
  /// Otherwise the user gets prompted again.
  String _readUserInput(
    String prompt, {
    bool allowEmptyInput = false,
  }) {
    final promptToWrite = "$prompt: ";
    stdout.write(promptToWrite);

    var userInput = stdin.readLineSync();

    while (userInput?.trim() == "" && !allowEmptyInput) {
      logger.error("Invalid input");

      stdout.write(promptToWrite);
      userInput = stdin.readLineSync();
    }

    return (userInput ?? "").trim();
  }

  /// Tries to read the package name from the attached process input.
  ///
  /// It is also printing a notice when the given user input does not match the short or long package name RegEx.
  String _readPackageName(Directory packageDirectory) {
    final defaultName = basename(packageDirectory.path).replaceAll("_", "-");
    final isValidDefaultName = validatePackageName(defaultName);

    while (true) {
      final userInput = isValidDefaultName
          ? _readUserInput(
              "Package name (default: $defaultName)",
              allowEmptyInput: true,
            )
          : _readUserInput("Package name");

      if (userInput.isEmpty && isValidDefaultName) {
        return defaultName;
      }

      if (validatePackageName(userInput)) {
        return userInput;
      }

      logger.error("""Invalid package name given.
Please ensure the package name follows the format:
- Short name: my-example-package-01
- Long name: @my-example-organization/my-example-package-01
- Long name: @my-example-organization123/my-example-package-01

NOTE:
The package name must start with an alphabetic character - digits or dashes are not valid!
The package name is also not allowed to end with a dash "-" character.""");
    }
  }

  SemanticVersion _readPackageVersion() {
    while (true) {
      final userInput = _readUserInput(
        "Package version (default: 0.1.0)",
        allowEmptyInput: true,
      );

      if (userInput == "") {
        return SemanticVersion(major: 0, minor: 1, patch: 0);
      }

      final parsedSemanticVersion = parseSemanticVersion(userInput);

      if (parsedSemanticVersion != null) {
        return parsedSemanticVersion;
      }

      logger.error("""Invalid semantic version given.
Please ensure the version follows the semantic versioning format:
- Major, minor, and patch version must be numbers separated by dots
- Pre-release and build metadata are optional

Examples:
- 1.0.0
- 1.0.0-alpha.1
- 1.0.0+build.1
- 1.0.0-alpha.1+build.1
""");
    }
  }

  String _readPackageLicense() {
    while (true) {
      final userInput = _readUserInput(
        "Package license (default: LicenseRef-proprietary)",
        allowEmptyInput: true,
      );

      if (userInput == "") {
        return "LicenseRef-proprietary";
      }

      if (isValidSpdxLicense(userInput)) {
        return userInput;
      }

      final lowercasedSpdxIdentifiers = lowercasedIdentifiers()
          .map((identifier) => "- $identifier")
          .join("\n");

      logger.error(
          """Invalid SPDX identifier given. Please provide a valid identifier or an empty string if the package should be proprietary.

Valid SPDX identifiers:
$lowercasedSpdxIdentifiers""");
    }
  }
}
