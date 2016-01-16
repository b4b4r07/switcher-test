#!/bin/zsh

__polling() {
    __get_autoload_files
    unfunction "${reply[@]}" &>/dev/null
}

add-zsh-hook precmd __polling
