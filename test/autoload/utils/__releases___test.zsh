#!/bin/zsh

: before
{
    source $ZPLUG_ROOT/zplug.zsh
    export ZPLUG_HOME=$ZPLUG_ROOT/test/_fixtures
    local -A zplugs
    local    expect actual
    local -i status_code
    local    repo
} &>/dev/null

each_after() {
    rm -rf "$ZPLUG_HOME/repos"
}

describe "__releases__"
    it "unknown option"
        expect="--unknown: Unknown option"
        actual="$(__releases__ --unknown 2>&1)"
        status_code=$status
        assert.equals "$expect" "$actual"
        assert.false $status_code
    end

    it "invalid repository"
        expect="repo: invalid repository type"
        actual="$(__releases__ "repo" 2>&1)"
        status_code=$status
        assert.equals "$expect" "$actual"
        assert.false $status_code
    end

    it "normal"
        __get_os() { __put "linux\n" }
        repo="peco/peco"
        expect="Installed ${repo:t} successfully"
        actual="$(__releases__ "$repo" 2>&1)"
        status_code=$status
        assert.equals "$expect" "$actual"
        assert.true $status_code
        each_after
    end

    it "--at option"
        __get_os() { __put "linux\n" }
        repo="peco/peco"
        expect="Installed ${repo:t} successfully"
        actual="$(
        __releases__ \
            --at "v0.3.5" \
            "$repo" 2>&1
        )"
        status_code=$status
        assert.equals "$expect" "$actual"
        assert.true $status_code
        expect="v0.3.5"
        actual="$(cat $ZPLUG_HOME/repos/$repo/INDEX)"
        assert.equals "$expect" "$actual"
        each_after
    end

    it "--of option"
        __get_os() { __put "linux\n" }
        repo="peco/peco"
        expect="Installed ${repo:t} successfully"
        actual="$(
        __releases__ \
            --at "v0.3.5" \
            --of "*darwin*" \
            "$repo" 2>&1
        )"
        status_code=$status
        assert.equals "$expect" "$actual"
        assert.true $status_code
        expect="v0.3.5"
        actual="$(cat $ZPLUG_HOME/repos/$repo/INDEX)"
        assert.equals "$expect" "$actual"
        expect="Mach-O"
        actual="$(file $ZPLUG_HOME/repos/$repo/peco)"
        assert.match "$expect" "$actual"
        each_after
    end

    it "--do option"
        __get_os() { __put "linux\n" }
        repo="peco/peco"
        expect="Installed ${repo:t} successfully"
        actual="$(
        __releases__ \
            --at "v0.3.5" \
            --of "*darwin*" \
            --do "touch $ZPLUG_HOME/repos/$repo/DO" \
            "$repo" 2>&1
        )"
        status_code=$status
        assert.equals "$expect" "$actual"
        assert.true $status_code
        expect="v0.3.5"
        actual="$(cat $ZPLUG_HOME/repos/$repo/INDEX)"
        assert.equals "$expect" "$actual"
        expect="Mach-O"
        actual="$(file $ZPLUG_HOME/repos/$repo/peco)"
        assert.match "$expect" "$actual"
        test -f "$ZPLUG_HOME/repos/$repo/DO"
        assert.true $status
        # Do Not Run
        # each_after
    end

    it "--at option Up-to-date"
        __get_os() { __put "linux\n" }
        repo="peco/peco"
        expect=""
        actual="$(
        __releases__ \
            --at "v0.3.5" \
            "$repo" 2>&1
        )"
        status_code=$status
        assert.equals "$expect" "$actual"
        assert.false $status_code
    end

    it "--at option Not Update"
        __get_os() { __put "linux\n" }
        repo="peco/peco"
        rm "$ZPLUG_HOME/repos/$repo/INDEX"
        echo "v0.3.1" >"$ZPLUG_HOME/repos/$repo/INDEX"
        expect=""
        actual="$(
        __releases__ \
            "$repo" 2>&1
        )"
        status_code=$status
        assert.equals "$expect" "$actual"
        assert.equals 128 $status_code
    end
end

: after
{
    each_after
    unset zplugs
    unset expect actual
    unset status_code
    unset repo
}
