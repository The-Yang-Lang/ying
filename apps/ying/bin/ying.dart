import 'package:ying_shared/logging/logger.dart';
import 'package:ying_shared/utils/stringify.dart';

void main(List<String> arguments) {
  var logger = Logger.withSimpleNameFromEnv("Main");

  logger.debug(
    "Got the following program arguments: ${stringify(arguments)}",
  );
}
