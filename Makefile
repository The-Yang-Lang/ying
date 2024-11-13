DART_EXECUTABLE=dart
MELOS_EXECUTABLE=melos

YING_ENTRYPOINT=./apps/ying/bin/ying.dart

NODEMON_EXECUTABLE=npx nodemon
NODEMON_DEFAULT_ARGS=-w ./apps -w ./packages -e dart

.PHONY: install
install:
	melos bootstrap

.PHONY: clear
clear:
	@cls || clear

.PHONY: run
run:
	${DART_EXECUTABLE} run ${YING_ENTRYPOINT}

.PHONY: debug
debug:
	${DART_EXECUTABLE} --pause-isolates-on-start --observe run ${YING_ENTRYPOINT} --help

.PHONY: test
test:
	${MELOS_EXECUTABLE} run test

.PHONY: watch
watch:
	${NODEMON_EXECUTABLE} ${NODEMON_DEFAULT_ARGS} -x "make clear run || exit 1"

.PHONY: watch-tests
watch-tests:
	${NODEMON_EXECUTABLE} ${NODEMON_DEFAULT_ARGS} -x "make clear test || exit 1"
