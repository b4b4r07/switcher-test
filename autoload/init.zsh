#!/bin/zsh

source "$ZPLUG_ROOT/lib/init.zsh"

__import "core/core"
__import "cli/cli"
__import "job/job"

local    f
local -a autoload_{dirs,files}
__get_autoload_dirs;  autoload_dirs=(  "${reply[@]}" )
__get_autoload_files; autoload_files=( "${reply[@]}" )

# Add autoload directories to fpath
fpath=(
"${autoload_dirs[@]}"
$fpath
)

for f in "${autoload_files[@]}"
do
    autoload -Uz "$f"
done

# autoload -Uz add-zsh-hook
# autoload -Uz compinit; compinit
