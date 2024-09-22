DART_EXECUTABLE=dart
MAIN_ENTRYPOINT=./bin/ying.dart

NODEMON_EXECUTABLE=npx nodemon
NODEMON_DEFAULT_ARGS=-w ./bin/ -w ./lib/ -e dart

.PHONY: clear
clear:
	@cls || clear

.PHONY: run
run:
	${DART_EXECUTABLE} run ${MAIN_ENTRYPOINT}

.PHONY: test
test:
	${DART_EXECUTABLE} test

.PHONY: watch
watch:
	${NODEMON_EXECUTABLE} ${NODEMON_DEFAULT_ARGS} -x "make clear run || exit 1"

.PHONY: watch-tests
watch-tests:
	${NODEMON_EXECUTABLE} ${NODEMON_DEFAULT_ARGS} -w ./test/ -x "make clear test || exit 1"
