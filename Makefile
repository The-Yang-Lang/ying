POETRY_EXECUTABLE=poetry
NODEMON_EXECUTABLE=npx nodemon

DEFAULT_NODEMON_ARGS=-w ./ -w ./Makefile -i ./examples/ -e py,ya,

.PHONY: clear
clear:
	@cls || clear

.PHONY: run
run:
	DEBUG=1 ${POETRY_EXECUTABLE} run ying

.PHONY: watch
watch:
	${NODEMON_EXECUTABLE} ${DEFAULT_NODEMON_ARGS} -x "make clear run || exit 1"

.PHONY: test
test:
	${POETRY_EXECUTABLE} run pytest -v --picked

.PHONY: watch-tests
watch-tests:
	${NODEMON_EXECUTABLE} ${DEFAULT_NODEMON_ARGS} -x "make clear test || exit 1"
