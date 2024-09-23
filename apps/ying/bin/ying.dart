import 'package:ying/logging/logger.dart';
import 'package:ying/utils/stringifier.dart';

void main(List<String> arguments) {
  var logger = Logger.withSimpleNameFromEnv("Main");

  logger.debug(
    "Got the following program arguments: ${Stringifier.stringify(arguments)}",
  );
}
