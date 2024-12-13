import 'package:ying_shared/languages/yang/expression.dart';
import 'package:ying_shared/languages/yang/type_argument.dart';
import 'package:ying_shared/utils/stringify.dart';

class TypeBuilder {
  String name;

  final List<TypeArgument> typeArguments;

  TypeBuilder(this.name) : typeArguments = [];

  TypeBuilder.withArguments(this.name, this.typeArguments);

  void setName(String newName) {
    name = newName;
  }

  void addTypeArgument(TypeArgument typeArgumentToAdd) {
    typeArguments.add(typeArgumentToAdd);
  }

  Type build() => Type.withArguments(name, typeArguments);
}

class Type extends Expression {
  final String name;

  final List<TypeArgument> _typeArguments;

  Type(this.name) : _typeArguments = [];

  Type.withArguments(this.name, this._typeArguments);

  get typeArguments => _typeArguments;

  static Type string() => Type("string");
  static Type boolean() => Type("boolean");
  static Type struct() => Type("struct");
  static Type interface() => Type("interface");

  static Type int8() => Type("int8");
  static Type int16() => Type("int16");
  static Type int32() => Type("int32");
  static Type int64() => Type("int64");
  static Type int128() => Type("int128");
  static Type int256() => Type("int256");
  static Type int512() => Type("int512");

  static Type float8() => Type("float8");
  static Type float16() => Type("float16");
  static Type float32() => Type("float32");
  static Type float64() => Type("float64");
  static Type float128() => Type("float128");
  static Type float256() => Type("float256");
  static Type float512() => Type("float512");

  static Type double8() => Type("double8");
  static Type double16() => Type("double16");
  static Type double32() => Type("double32");
  static Type double64() => Type("double64");
  static Type double128() => Type("double128");
  static Type double256() => Type("double256");
  static Type double512() => Type("double512");

  @override
  operator ==(Object other) =>
      other is Type &&
      name == other.name &&
      _typeArguments.length == other._typeArguments.length &&
      _typeArguments.indexed.every(
        (entry) => entry.$2 == other._typeArguments[entry.$1],
      );

  @override
  int get hashCode => Object.hash(name, Object.hashAll(_typeArguments));

  @override
  String toString() {
    return stringifyInstance("Type", fields: {
      "name": name,
      "typeArguments": typeArguments,
    });
  }
}
