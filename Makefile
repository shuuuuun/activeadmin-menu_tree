.PHONY: rake/* rbs/* typeprof/* steep/*

setup:
	bin/setup

concole:
	bin/concole

rake/tasks:
	bundle exec rake --tasks

rake/%:
	bundle exec rake $*

rbs/prototype: rbs/prototype/lib

rbs/prototype/lib:
	for file in $$(find lib -name "*.rb" -type f | sort); do \
		echo $${file}; \
		mkdir -p sig/$$(dirname $${file}); \
		rbs prototype rb $${file} > sig/$${file}s; \
	done

# rbs/prototype/runtime:
# 	rbs prototype runtime -R spec/spec_helper.rb

rbs/validate:
	rbs validate

typeprof/lib:
	typeprof lib/**/*.rb

steep/check:
	steep check
