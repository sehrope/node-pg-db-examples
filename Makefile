default: package

clean:
	rm -rf node_modules
	rm -rf lib

compile:
	node_modules/.bin/coffee --bare --output lib --compile src

build:
	npm install
	node_modules/.bin/coffee --bare --output lib --compile src

package: clean build

test-basic:
	foreman run node_modules/.bin/coffee src/basic.coffee

test-tx:
	foreman run node_modules/.bin/coffee src/tx.coffee

.PHONY: clean default build package test-basic test-tx
