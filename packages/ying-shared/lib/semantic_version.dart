final semanticVersionRegex = RegExp(
  r'^'
  r'(?<major>0|[1-9]\d*)\.(?<minor>0|[1-9]\d*)\.(?<patch>0|[1-9]\d*)'
  r'(?:-(?<preRelease>(?:[0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*)))?'
  r'(?:\+(?<build>(?:[0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*)))?'
  r'$',
);

/// Tries to parse the given [input] into a [SemanticVersion].
///
/// Returns null when the given [input] is not a valid semantic version.
SemanticVersion? parseSemanticVersion(String input) {
  final match = semanticVersionRegex.firstMatch(input);

  if (match == null) {
    return null;
  }

  // Parse core version components
  final major = int.parse(match.namedGroup('major')!);
  final minor = int.parse(match.namedGroup('minor')!);
  final patch = int.parse(match.namedGroup('patch')!);

  // Parse pre-release identifiers if available
  final preRelease = match
      .namedGroup('preRelease')
      ?.split('.')
      .where((id) => id.isNotEmpty)
      .toList();

  // Parse build identifiers if available
  final build = match
      .namedGroup('build')
      ?.split('.')
      .where((id) => id.isNotEmpty)
      .toList();

  return SemanticVersion(
    major: major,
    minor: minor,
    patch: patch,
    preRelease: preRelease,
    build: build,
  );
}

class SemanticVersion {
  final int major;
  final int minor;
  final int patch;
  final List<String>? preRelease;
  final List<String>? build;

  SemanticVersion({
    required this.major,
    required this.minor,
    required this.patch,
    this.preRelease,
    this.build,
  });

  @override
  String toString() {
    final core = '$major.$minor.$patch';
    final preReleaseStr = preRelease != null ? '-${preRelease!.join('.')}' : '';
    final buildStr = build != null ? '+${build!.join('.')}' : '';

    return '$core$preReleaseStr$buildStr';
  }
}
