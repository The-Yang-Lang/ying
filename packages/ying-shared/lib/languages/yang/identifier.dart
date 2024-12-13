import 'package:ying_shared/languages/yang/type_argument.dart';

abstract class Identifier {}

class UnresolvedIdentifier extends Identifier {
  final String base;
  final List<TypeArgument> typeArguments;

  UnresolvedIdentifier(this.base) : typeArguments = [];

  UnresolvedIdentifier.withTypeArguments(this.base, this.typeArguments);
}
