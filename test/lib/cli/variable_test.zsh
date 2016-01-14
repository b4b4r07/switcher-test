#!/bin/zsh

: before
{
    export ZPLUG_HOME=$ZPLUG_ROOT/test/_fixtures
    source $ZPLUG_ROOT/lib/cli/variable.zsh
    source $ZPLUG_ROOT/zplug.zsh
    local -A zplugs
    local    expect actual
    local -a expects actuals
    local -i status_code
} &>/dev/null

describe "lib/cli/variable.zsh"
    it ""
    end
end
