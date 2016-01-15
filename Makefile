ZPLUG_ROOT := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
ZSPEC_URL  := https://raw.githubusercontent.com/b4b4r07/zspec/master/bin/zspec

skip_files := __clone__ __releases__ __install__ __update__
candidates := $(wildcard $(PWD)/test/*/*/*_test.zsh)
exclusions := $(foreach file,$(skip_files),$(wildcard $(PWD)/test/*/*/$(file)_test.zsh))
test_files := $(filter-out $(exclusions), $(candidates))

all:

zspec:
	@test -f $(PWD)/bin/zspec || curl -L $(ZSPEC_URL) -o $(PWD)/bin/zspec
	@test -x $(PWD)/bin/zspec || chmod 755 $(PWD)/bin/zspec

minitest: zspec
	@ZPLUG_ROOT=$(PWD) $(PWD)/bin/zspec $(test_files)

test: zspec
	@ZPLUG_ROOT=$(PWD) $(PWD)/bin/zspec $(candidates)

.PHONY: zspec minitest test
