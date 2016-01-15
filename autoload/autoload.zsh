#!/bin/zsh

source "$ZPLUG_ROOT/autoload/init.zsh"

__import "core/core"

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
