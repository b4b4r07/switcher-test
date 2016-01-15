#!/bin/zsh

source "$ZPLUG_ROOT/lib/init.zsh"

__import "cli/variable" # require
__import "core/core"
__import "job/job"
__import "print/print"

if ! __zsh_version 4.3.9; then
    __die "zplug does not work this version of zsh $ZSH_VERSION.\n"
    __die "You must use zsh 4.3.9 or later.\n"
    return 1
fi

if (( ! $+commands[git] )); then
    __die "git: not found in \$PATH\n"
    __die "zplug depends on git 1.7 or later.\n"
    return 1
fi

local    cmd
local -a autoload_dirs autoload_files

__get_autoload_dirs;  autoload_dirs=(  "${reply[@]}" )
__get_autoload_files; autoload_files=( "${reply[@]}" )

fpath=(
"${autoload_dirs[@]}"
$fpath
)

for cmd in "${autoload_files[@]}"
do
    autoload -Uz "$cmd"
done
