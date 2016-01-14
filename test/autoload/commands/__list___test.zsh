#!/bin/zsh

: before
{
    source $ZPLUG_ROOT/zplug.zsh
    local -A zplugs
    local    expect actual
    local -i status_code
    fzf() { head -1; }
} &>/dev/null

describe "__list__"
    it "empty zplugs"
        zplugs=()
        expect="there is"
        actual="$(zplug list 2>&1)"
        status_code=$status
        assert.match  "$expect" "$actual"
        assert.equals  $status_code 1
    end

    it "unknown option"
        zplugs=("" "")
        expect="--unknown:"
        actual="$(zplug list --unknown 2>&1)"
        status_code=$status
        assert.match  "$expect" "$actual"
        assert.equals $status_code 1
    end

    it "--select option"
        zplugs=("b4b4r07/zplug" "as:plugin")
        ZPLUG_FILTER="fzf"
        expect="b4b4r07/zplug"
        actual="$(zplug list --select 2>&1 | perl -pe 's/\x1b\[[0-9;]*m//g')"
        status_code=$pipestatus[1]
        assert.match  "$expect" "$actual"
        assert.equals $status_code 0
    end

    it "argument repo"
        zplugs=("b4b4r07/zplug" "as:plugin")
        expect="b4b4r07/zplug"
        actual="$(zplug list b4b4r07/zplug 2>&1 | perl -pe 's/\x1b\[[0-9;]*m//g')"
        status_code=$pipestatus[1]
        assert.match  "$expect" "$actual"
        assert.equals $status_code 0
    end

    it "argument repo 2"
        zplugs=("b4b4r07/zplug" "as:plugin")
        expect="b4b4r07/zplug"
        actual="$(zplug list b4 2>&1 | perl -pe 's/\x1b\[[0-9;]*m//g')"
        status_code=$pipestatus[1]
        assert.match  "$expect" "$actual"
        assert.equals $status_code 0
    end

    it "argument repo 3"
        zplugs=("b4b4r07/zplug" "as:plugin")
        expect="b5: not found"
        actual="$(zplug list b5 2>&1 | perl -pe 's/\x1b\[[0-9;]*m//g')"
        status_code=$pipestatus[1]
        assert.match  "$expect" "$actual"
        assert.equals $status_code 0
    end

    it "multiple args"
        zplugs=(
        "b4b4r07/zplug" "as:plugin"
        "b4b4r07/enhancd" "as:plugin"
        )
        expect="b4b4r07/enhancd  =>  as:plugin
b4b4r07/zplug  =>  as:plugin"
        actual="$(zplug list "zpl" "enh" 2>&1 | perl -pe 's/\x1b\[[0-9;]*m//g')"
        status_code=$pipestatus[1]
        assert.match  "$expect" "$actual"
        assert.equals $status_code 0
    end

    it "no argument"
        zplugs=("b4b4r07/zplug" "as:plugin")
        expect="b4b4r07/zplug"
        actual="$(zplug list 2>&1 | perl -pe 's/\x1b\[[0-9;]*m//g')"
        status_code=$pipestatus[1]
        assert.match  "$expect" "$actual"
        assert.equals $status_code 0
    end
end

: after
{
    unset zplugs
    unset expect actual
    unset expects actuals
    unset status_code
} &>/dev/null
