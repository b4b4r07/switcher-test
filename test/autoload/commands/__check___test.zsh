#!/bin/zsh

: before
{
    export ZPLUG_HOME=$ZPLUG_ROOT/test/_fixtures
    source $ZPLUG_ROOT/zplug.zsh
    local -A zplugs
    local    expect actual
    local -i status_code
} &>/dev/null

before_each() {
    source $ZPLUG_ROOT/test/_helpers/create_mock_repos.zsh
    source $ZPLUG_ROOT/test/_helpers/init_mock_repos.zsh
    create_mock_plugin "foo/bar"
    init_mock_repos "foo/bar"
}
after_each() {
    rm -rf $ZPLUG_HOME/repos/**/.git(N-/)
}

describe "__check__"
    it "unknown option"
        expect="--unknown: Unknown option"
        actual="$(zplug check --unknown 2>&1)"
        status_code=$status
        assert.equals "$expect" "$actual"
        assert.false $status_code
    end

    it "check returns true"
        before_each
        zplugs=("foo/bar" "dir:$ZPLUG_HOME/repos/foo/bar")
        zplug check "foo/bar"
        status_code=$status
        assert.true $status_code
        after_each
    end

    it "check returns false"
        zplugs=()
        zplug check "foo/bar" &>/dev/null
        status_code=$status
        assert.false $status_code
    end

    it "check returns false with verbose message"
        zplugs=()
        expect="- foo/bar: not installed"
        actual="$(zplug check --verbose "foo/bar" 2>&1)"
        status_code=$status
        assert.equals "$expect" "$(perl -pe 's/\x1b\[[0-9;]*m//g' <<<"$actual")"
        assert.false $status_code
    end
end

: after
{
    unset zplugs
    unset expect actual
    unset expects actuals
    unset status_code
} &>/dev/null
