#!/bin/zsh

__is_cli() {
    [[ $- =~ s ]]
}

__zpluged() {
    if [[ $# -eq 0 ]]; then
        (( $+zplugs ))
        return $status
    else
        (( $+zplugs[$1] ))
        return $status
    fi
}

__get_autoload_dirs() {
    reply=(
    "$ZPLUG_ROOT/autoload/commands"
    "$ZPLUG_ROOT/autoload/utils"
    )
}

__get_autoload_paths() {
    local -a fs
    __get_autoload_dirs
    fs=( "${^reply[@]}"/__*(N-.) )
    (( $#fs > 0 )) && reply=( "${fs[@]}" )
}

__get_autoload_files() {
    __get_autoload_paths
    (( $#reply > 0 )) && reply=( "${reply[@]:t}" )
}

__in_array() {
    local e="$1"
    local -a arr
    shift

    arr=( "${@}" )
    (( $arr[(i)$e] != ${#arr} + 1 ))
}

__get_filter() {
    local item x

    for item in "${(s.:.)1}"
    do
        x="${item%% *}"
        # Check if x is available
        if (( $+commands[$x] )); then
            echo "$x"
            return 0
        else
            continue
        fi
    done

    return 1
}

__version_requirement() {
    local -i idx
    local -a min val

    [[ $1 == $2 ]] && return 0

    val=("${(s:.:)1}")
    min=("${(s:.:)2}")

    for (( idx=1; idx <= $#val; idx++ ))
    do
        if (( val[$idx] > ${min[$idx]:-0} )); then
            return 0
        elif (( val[$idx] < ${min[$idx]:-0} )); then
            return 1
        fi
    done

    return 1
}

__git_version() {
    __version_requirement "${(M)${(z)"$(git --version)"}:#[0-9]*[0-9]} " "$@"
    return $status
}

__zsh_version() {
    __version_requirement "$ZSH_VERSION" "$@"
    return $status
}

__get_os() {
    typeset -gx PLATFORM
    local os

    os="${(L)OSTYPE-"$(uname)"}"
    case "$os" in
        *'linux'*)  PLATFORM='linux'   ;;
        *'darwin'*) PLATFORM='darwin'  ;;
        *'bsd'*)    PLATFORM='bsd'     ;;
        *)          PLATFORM='unknown' ;;
    esac

    echo "$PLATFORM"
}

__glob2regexp() {
    local -i i=0
    local    glob char

    glob="$1"
    if [[ -z $glob ]]; then
        return 1
    fi

    printf "^"
    for ((; i < ${#glob}; i++)); do
        char="${glob:$i:1}"
        case $char in
            \*)
                printf '.*'
                ;;
            .)
                printf '\.'
                ;;
            "{")
                printf '('
                ;;
            "}")
                printf ')'
                ;;
            ,)
                printf '|'
                ;;
            "?")
                printf '.'
                ;;
            \\)
                printf '\\\\'
                ;;
            *)
                printf "$char"
                ;;
        esac
    done
    printf "$\n"
}
