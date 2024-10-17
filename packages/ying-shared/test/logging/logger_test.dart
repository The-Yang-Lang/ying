import 'package:clock/clock.dart';
import 'package:test/test.dart';
import 'package:ying_shared/logging/log_level.dart';
import 'package:ying_shared/logging/logger.dart';

void main() {
  test('create a new logger with the given name parts and LogLevel', () {
    final logger = Logger(["unit", "test"], LogLevel.none);

    expect(logger.nameParts, ["unit", "test"]);
    expect(logger.currentLevel, LogLevel.none);
  });

  test('create a new logger with a simple name and LogLevel', () {
    final logger = Logger.withSimpleName("unit-test", LogLevel.none);

    expect(logger.nameParts, ["unit-test"]);
    expect(logger.currentLevel, LogLevel.none);
  });

  test(
    'create a new logger with a simple name where the LogLevel is determined by the environment variables',
    () {
      final logger = Logger.withSimpleNameFromEnv("unit-test");

      expect(logger.nameParts, ["unit-test"]);
      expect(logger.currentLevel, LogLevel.info);
    },
  );

  group('extending the logger', () {
    test('it should append the new name and use the current LogLevel', () {
      final logger = Logger.withSimpleName("unit", LogLevel.none);
      final subLogger = logger.extend("test");

      expect(subLogger.nameParts, ["unit", "test"]);
      expect(subLogger.currentLevel, LogLevel.none);
    });

    test('it should append the new name and use the given LogLevel', () {
      final logger = Logger.withSimpleName("unit", LogLevel.none);
      final subLogger = logger.extend("test", newLevel: LogLevel.error);

      expect(subLogger.nameParts, ["unit", "test"]);
      expect(subLogger.currentLevel, LogLevel.error);
    });
  });

  group('logging messages', () {
    test('it should log a message with the error LogLevel', () {
      withClock(Clock.fixed(DateTime(2024)), () {
        expect(() {
          final logger = Logger.withSimpleName("unit", LogLevel.trace);

          logger.error("unit-test");
        }, prints("[01.01.2024] [00:00:00.00] [ERROR] [unit] unit-test\n"));
      });
    });

    test('it should log a message with the warn LogLevel', () {
      withClock(Clock.fixed(DateTime(2024)), () {
        expect(() {
          final logger = Logger.withSimpleName("unit", LogLevel.trace);

          logger.warn("unit-test");
        }, prints("[01.01.2024] [00:00:00.00] [WARN ] [unit] unit-test\n"));
      });
    });

    test('it should log a message with the info LogLevel', () {
      withClock(Clock.fixed(DateTime(2024)), () {
        expect(() {
          final logger = Logger.withSimpleName("unit", LogLevel.trace);

          logger.info("unit-test");
        }, prints("[01.01.2024] [00:00:00.00] [INFO ] [unit] unit-test\n"));
      });
    });

    test('it should log a message with the debug LogLevel', () {
      withClock(Clock.fixed(DateTime(2024)), () {
        expect(() {
          final logger = Logger.withSimpleName("unit", LogLevel.trace);

          logger.debug("unit-test");
        }, prints("[01.01.2024] [00:00:00.00] [DEBUG] [unit] unit-test\n"));
      });
    });

    test('it should log a message with the trace LogLevel', () {
      withClock(Clock.fixed(DateTime(2024)), () {
        expect(() {
          final logger = Logger.withSimpleName("unit", LogLevel.trace);

          logger.trace("unit-test");
        }, prints("[01.01.2024] [00:00:00.00] [TRACE] [unit] unit-test\n"));
      });
    });
  });
}
