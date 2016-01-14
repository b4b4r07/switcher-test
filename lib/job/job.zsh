#!/bin/zsh

__polling() {
    __get_autoload_files
    unfunction "${reply[@]}" &>/dev/null
    set -m
}

add-zsh-hook precmd __polling
