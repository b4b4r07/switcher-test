typeset -gx ZPLUG_ROOT="${${(%):-%N}:A:h}"
typeset -gx PATH="$ZPLUG_ROOT/bin:$PATH"

fpath=(
$ZPLUG_ROOT/autoload(N-/)
$ZPLUG_ROOT/src/completions(N-/)
$fpath
)

autoload -Uz zplug
