import 'package:ying_shared/text_span.dart';

enum DiagnosticSeverity {
  error(1),
  warning(2),
  information(3),
  hint(4);

  final int value;

  const DiagnosticSeverity(this.value);
}

enum DiagnosticTag {
  unnecessary(1),
  deprecated(2);

  final int value;

  const DiagnosticTag(this.value);
}

class Location {
  final String uri;

  final TextSpan range;

  const Location(this.uri, this.range);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Location &&
          runtimeType == other.runtimeType &&
          uri == other.uri &&
          range == other.range;

  @override
  int get hashCode => uri.hashCode ^ range.hashCode;
}

class DiagnosticRelatedInformation {
  final Location location;

  final String message;

  const DiagnosticRelatedInformation(this.location, this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiagnosticRelatedInformation &&
          runtimeType == other.runtimeType &&
          location == other.location &&
          message == other.message;

  @override
  int get hashCode => location.hashCode ^ message.hashCode;
}

class Diagnostic {
  /// The range at which the message applies.
  final TextSpan range;

  /// The diagnostic's severity. To avoid interpretation mismatches when a
  /// server is used with different clients it is highly recommended that
  /// servers always provide a severity value. If omitted, it’s recommended
  /// for the client to interpret it as an Error severity.
  final DiagnosticSeverity severity;

  /// The diagnostic's code, which might appear in the user interface.
  final String? code;

  /// A human-readable string describing the source of this
  /// diagnostic, e.g. 'typescript' or 'super lint'.
  final String? source;

  /// The diagnostic's message.
  final String message;

  /// Additional metadata about the diagnostic.
  final List<DiagnosticTag>? tags;

  /// An array of related diagnostic information, e.g. when symbol-names within
  /// a scope collide all definitions can be marked via this property.
  final List<DiagnosticRelatedInformation>? relatedInformation;

  final dynamic data;

  const Diagnostic(
    this.range,
    this.message, {
    this.severity = DiagnosticSeverity.error,
    this.code,
    this.source,
    this.tags,
    this.relatedInformation,
    this.data,
  });

  Diagnostic.error(
    this.range,
    this.message, {
    this.code,
    this.source,
    this.tags,
    this.relatedInformation,
    this.data,
  }) : severity = DiagnosticSeverity.error;

  Diagnostic.warning(
    this.range,
    this.message, {
    this.code,
    this.source,
    this.tags,
    this.relatedInformation,
    this.data,
  }) : severity = DiagnosticSeverity.warning;

  Diagnostic.information(
    this.range,
    this.message, {
    this.code,
    this.source,
    this.tags,
    this.relatedInformation,
    this.data,
  }) : severity = DiagnosticSeverity.information;

  Diagnostic.hint(
    this.range,
    this.message, {
    this.code,
    this.source,
    this.tags,
    this.relatedInformation,
    this.data,
  }) : severity = DiagnosticSeverity.hint;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Diagnostic &&
          runtimeType == other.runtimeType &&
          range == other.range &&
          severity == other.severity &&
          code == other.code &&
          source == other.source &&
          message == other.message &&
          tags == other.tags &&
          relatedInformation == other.relatedInformation &&
          data == other.data;

  @override
  int get hashCode =>
      range.hashCode ^
      severity.hashCode ^
      code.hashCode ^
      source.hashCode ^
      message.hashCode ^
      tags.hashCode ^
      relatedInformation.hashCode ^
      data.hashCode;
}
