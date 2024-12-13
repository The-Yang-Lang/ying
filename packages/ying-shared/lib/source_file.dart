import 'dart:io';

class SourceFile {
  /// The path to the source file
  final String uri;

  /// The content of the source file
  final String content;

  /// The length of the content of the source file
  final int contentLength;

  SourceFile(this.uri, this.content) : contentLength = content.length;

  /// Returns the character at the given [position].
  ///
  /// Returns null when the [position] is out of bounds.
  String? getCharacterAtPosition(int position) {
    if (position < 0) {
      return null;
    }

    if (position >= content.length) {
      return null;
    }

    return content[position];
  }

  /// Tries to read the file at the given [path] and returns
  /// a [SourceFile] instance with the content read from the file.
  ///
  /// Throws an exception if the file does not exist.
  static Future<SourceFile> readFromPath(String path) async {
    final file = File(path);

    if (file.existsSync() == false) {
      throw Exception("File at $path does not exist");
    }

    final fileContents = await file.readAsString();
    final fileUri = "file://${file.absolute.path}";

    return SourceFile(fileUri, fileContents);
  }
}
