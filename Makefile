ZPLUG_ROOT := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
ZSPEC_URL  := https://raw.githubusercontent.com/b4b4r07/zspec/master/bin/zspec
ZSPEC      := $(ZPLUG_ROOT)/bin/zspec
MANPAGE    := $(PWD)/doc/man/man1/zplug.1
MANPATH    := /usr/local/share/man/man1

SKIP_FILES := __clone__ __releases__ __install__ __update__
CANDIDATES := $(wildcard $(PWD)/test/*/*/*_test.zsh)
EXCLUSIONS := $(foreach file,$(SKIP_FILES),$(wildcard $(PWD)/test/*/*/$(file)_test.zsh))
TEST_FILES := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

.PHONY: all install man zspec minitest test

all:

install: man

man:
	@cp -v -f $(MANPAGE) $(MANPATH)

zspec:
	@test -f $(ZSPEC) || curl -L $(ZSPEC_URL) -o $(ZSPEC)
	@test -x $(ZSPEC) || chmod 755 $(ZSPEC)

minitest: zspec
	@ZPLUG_ROOT=$(ZPLUG_ROOT) $(ZSPEC) $(TEST_FILES)

test: zspec
	@ZPLUG_ROOT=$(ZPLUG_ROOT) $(ZSPEC) $(CANDIDATES)
