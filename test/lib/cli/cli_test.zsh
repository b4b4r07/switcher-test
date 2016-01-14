#!/bin/zsh

: before
{
    export ZPLUG_HOME=$ZPLUG_ROOT/test/_fixtures
    source $ZPLUG_ROOT/lib/cli/cli.zsh
    source $ZPLUG_ROOT/zplug.zsh
    local -A zplugs
    local    expect actual
    local -a expects actuals
    local -i status_code
} &>/dev/null

describe "lib/cli/cli.zsh"
    it ""
    end
end
