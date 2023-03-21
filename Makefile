.PHONY: rake/* rbs/* typeprof/* steep/*

rake/tasks:
	bundle exec rake --tasks

rbs/prototype: rbs/prototype/lib

rbs/prototype/lib:
	for file in $$(find lib -name "*.rb" -type f | sort); do \
		echo $${file}; \
		mkdir -p sig/$$(dirname $${file}); \
		bundle exec rbs prototype rb $${file} > sig/$${file}s; \
	done

# rbs/prototype/runtime:
# 	rbs prototype runtime -R spec/spec_helper.rb

rbs/validate:
	bundle exec rbs validate

rbs/collection/update:
	bundle exec rbs collection update

# typeprof/lib:
# 	bundle exec typeprof lib/**/*.rb

typeprof/lib:
	for file in $$(find lib -name "*.rb" -type f | sort); do \
		echo $${file}; \
		mkdir -p sig/$$(dirname $${file}); \
		bundle exec typeprof sig/$${file}s $${file} -o sig/$$(dirname $${file})/$$(basename -s .rb $${file}).gen.rbs; \
	done

steep/check:
	bundle exec steep check

rubocop:
	bundle exec rubocop

rubocop/autocorrect:
	bundle exec rubocop --autocorrect
