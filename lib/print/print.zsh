#!/bin/zsh

__die() {
    command printf -- "$@" >&2
    # builtin printf -- "$@" >&2
    # builtin printf -- "$argv[1]" "$argv[2,-1]" >&2
}

__put() {
    command printf -- "$@"
    # builtin printf -- "$@"
    # builtin printf -- "$argv[1]" "$argv[2,-1]"
}
