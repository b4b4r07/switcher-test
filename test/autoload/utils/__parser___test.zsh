#!/bin/zsh

: before
{
    source $ZPLUG_ROOT/zplug.zsh
    local -A zplugs
    local    expect actual
    local -a expects actuals
    local -i status_code
} &>/dev/null

describe "__parser__"
    it "too few arguments"
        expect="too few arguments"
        actual="$(__parser__ 2>&1)"
        status_code=$status
        assert.match  "$expect" "$actual"
        assert.equals $status_code 1
    end

    it "standard plugin"
        zplugs=("username/reponame" "")
        expects=(
        as        plugin
        at        master
        ignore    -EMP-
        commit    -EMP-
        dir       -EMP-
        of        -EMP-
        from      github
        do        -EMP-
        file      -EMP-
        name      username/reponame
        nice      0
        if        -EMP-
        frozen    0
        on        -EMP-
        )
        actuals=( ${(@f)"$(__parser__ "username/reponame")"} )
        assert.array_equals expects actuals
    end

    it "standard command"
        zplugs=("username/reponame" "as:command")
        expects=(
        as        command
        at        master
        ignore    -EMP-
        commit    -EMP-
        dir       -EMP-
        of        -EMP-
        from      github
        do        -EMP-
        file      -EMP-
        name      username/reponame
        nice      0
        if        -EMP-
        frozen    0
        on        -EMP-
        )
        actuals=( ${(@f)"$(__parser__ "username/reponame")"} )
        assert.array_equals expects actuals
    end

    it "Oh My Zsh"
        zplugs=("$_zplug_omz_repo" "")
        expects=(
        as        plugin
        at        master
        ignore    -EMP-
        commit    -EMP-
        dir       -EMP-
        of        -EMP-
        from      github
        do        -EMP-
        file      -EMP-
        name      "$_zplug_omz_repo"
        nice      -10
        if        -EMP-
        frozen    0
        on        -EMP-
        )
        actuals=( ${(@f)"$(__parser__ "$_zplug_omz_repo")"} )
        assert.array_equals expects actuals
    end

    it "Oh My Zsh with nice:1"
        zplugs=("$_zplug_omz_repo" "nice:1")
        expects=(
        as        plugin
        at        master
        ignore    -EMP-
        commit    -EMP-
        dir       -EMP-
        of        -EMP-
        from      github
        do        -EMP-
        file      -EMP-
        name      "$_zplug_omz_repo"
        nice      1
        if        -EMP-
        frozen    0
        on        -EMP-
        )
        actuals=( ${(@f)"$(__parser__ "$_zplug_omz_repo")"} )
        assert.array_equals expects actuals
    end

    it "Oh My Zsh with nice:-20"
        zplugs=("$_zplug_omz_repo" "nice:-20")
        expects=(
        as        plugin
        at        master
        ignore    -EMP-
        commit    -EMP-
        dir       -EMP-
        of        -EMP-
        from      github
        do        -EMP-
        file      -EMP-
        name      "$_zplug_omz_repo"
        nice      -20
        if        -EMP-
        frozen    0
        on        -EMP-
        )
        actuals=( ${(@f)"$(__parser__ "$_zplug_omz_repo")"} )
        assert.array_equals expects actuals
    end
end

: after
{
    unset zplugs
    unset expect actual
    unset status_code
}