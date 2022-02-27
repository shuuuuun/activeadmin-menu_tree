.PHONY: rake/* rbs/* typeprof/* steep/*

rake/tasks:
	bundle exec rake --tasks

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

rbs/collection/update:
	rbs collection update

# typeprof/lib:
# 	# typeprof lib/**/*.rb
# 	typeprof lib/activeadmin/menu_tree.rb

typeprof/lib:
	for file in $$(find lib -name "*.rb" -type f | sort); do \
		echo $${file}; \
		mkdir -p sig/$$(dirname $${file}); \
		typeprof sig/$${file}s $${file} -o sig/$$(dirname $${file})/$$(basename -s .rb $${file}).gen.rbs; \
	done

steep/check:
	steep check
