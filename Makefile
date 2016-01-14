ZPLUG_ROOT = $(PWD)
ZSPEC_URL  = https://raw.githubusercontent.com/b4b4r07/zspec/master/bin/zspec

all:

test:
	@test -f $(PWD)/bin/zspec || curl -L $(ZSPEC_URL) -o $(PWD)/bin/zspec
	@test -x $(PWD)/bin/zspec || chmod 755 $(PWD)/bin/zspec
	@ZPLUG_ROOT=$(PWD) $(PWD)/bin/zspec --verbose "$(PWD)/test/**/*_test.zsh"

.PHONY: test
