import 'package:ying_shared/languages/yang/type.dart';

class TypeArgumentBuilder {
  String name;

  List<Type> implementsClauses;

  TypeArgumentBuilder(this.name, {List<Type>? implementsClauses})
      : implementsClauses = implementsClauses ?? [];

  TypeArgumentBuilder.withImplementsClauses(this.name, this.implementsClauses);

  void addImplementsClause(Type implementsClauseToAdd) {
    implementsClauses.add(implementsClauseToAdd);
  }

  TypeArgument build() => TypeArgument(
        name,
        implementsClauses: implementsClauses,
      );
}

class TypeArgument {
  final String name;
  final List<Type> _implementsClauses;

  TypeArgument(
    this.name, {
    List<Type>? implementsClauses,
  }) : _implementsClauses = implementsClauses ?? [];

  TypeArgument.fromName(this.name) : _implementsClauses = [];

  @override
  operator ==(Object other) =>
      other is TypeArgument &&
      name == other.name &&
      _implementsClauses.length == other._implementsClauses.length &&
      _implementsClauses.indexed
          .every((entry) => entry.$2 == other._implementsClauses[entry.$1]);

  @override
  int get hashCode => Object.hash(
        name,
        Object.hashAll(_implementsClauses),
      );
}
