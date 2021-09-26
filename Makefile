.PHONY: rake/* rbs/* typeprof/* steep/*

rake/tasks:
	rake --tasks

rbs/prototype: rbs/prototype/lib

rbs/prototype/lib:
	for file in $$(find lib -name "*.rb" -type f | sort); do \
		echo $${file}; \
		mkdir -p sig/$$(dirname $${file}); \
		rbs prototype rb $${file} > sig/$${file}s; \
	done

# rbs/prototype/runtime:
# 	rbs prototype runtime -R spec/spec_helper.rb

typeprof/lib:
	typeprof lib/**/*.rb

steep/check:
	steep check
