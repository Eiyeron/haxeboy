
build/js:
	@haxe build.hxml

test:
	@haxe test.hxml
	@neko run_tests.n

all: build/haxeboy.js

clean:
	@rm build/haxeboy.js

.PHONY: all test clean
