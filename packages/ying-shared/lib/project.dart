import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:ying_shared/project_configuration.dart';

void initializeProject(
  Directory projectDirectory,
  ProjectConfiguration projectConfiguration,
) {
  if (projectDirectory.existsSync() == false) {
    projectDirectory.createSync(recursive: true);
  }

  final projectConfigurationFile = File(
    join(
      projectDirectory.path,
      "ying.json",
    ),
  );

  final jsonEncoder = JsonEncoder.withIndent("\t");
  final encodedProjectConfiguration = "${jsonEncoder.convert(
    projectConfiguration,
  )}\n";

  projectConfigurationFile.writeAsStringSync(encodedProjectConfiguration);

  _createBoilerplateFiles(projectDirectory);
}

void _createBoilerplateFiles(Directory projectDirectory) {
  final entrypointFile = File(
    join(projectDirectory.path, "src", "main.ya"),
  );

  if (entrypointFile.existsSync() == false) {
    entrypointFile.createSync(recursive: true);

    entrypointFile.writeAsStringSync("""import { stdout } from "process";

void main() {
\tstdout.write_line("Hello world! How are you?");
}
""");
  }
}
