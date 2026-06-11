# shellrc-hooks component
# Provides lifecycle hooks for ShellRc initialization.
#
# shellrc-atnext fn  — register a hook that runs after each load-component
# shellrc-atexit fn  — register a hook that runs once at the end of init
# shellrc-next       — execute all "next" hooks (called by load-component)
# shellrc-exit       — execute "next" hooks, then "exit" hooks, then clean up
#
# Safe to source in both bash and zsh; intended to be loaded early so other
# components can register callbacks during initialization.

declare -ga __shellrc_atnext_funcs=()
declare -ga __shellrc_atexit_funcs=()

# Register one or more function names to run after each load-component.
# Usage: shellrc-atnext fn1 [fn2 ...]
shellrc-atnext() {
    if [[ "$#" -lt 1 ]]; then
        echo "shellrc-atnext: requires at least one function name" 1>&2
        return 1
    fi

    local fn
    for fn in "$@"; do
        [[ -z "$fn" ]] && continue
        __shellrc_atnext_funcs+=("$fn")
    done
}

# Register one or more function names to run at shellrc exit.
# Usage: shellrc-atexit fn1 [fn2 ...]
shellrc-atexit() {
    if [[ "$#" -lt 1 ]]; then
        echo "shellrc-atexit: requires at least one function name" 1>&2
        return 1
    fi

    local fn
    for fn in "$@"; do
        [[ -z "$fn" ]] && continue
        __shellrc_atexit_funcs+=("$fn")
    done
}

# Execute all "next" hooks in registration order.
shellrc-next() {
    local fn
    for fn in "${__shellrc_atnext_funcs[@]:-}"; do
        [[ -z "$fn" ]] && continue
        if declare -f "$fn" >/dev/null 2>&1; then
            "$fn"
        fi
    done
}

# Execute "next" hooks, then "exit" hooks, then clean up.
shellrc-exit() {
    shellrc-next

    local fn
    for fn in "${__shellrc_atexit_funcs[@]:-}"; do
        [[ -z "$fn" ]] && continue
        if declare -f "$fn" >/dev/null 2>&1; then
            "$fn"
        fi
    done

    __shellrc_atnext_funcs=()
    __shellrc_atexit_funcs=()
    unset __shellrc_atnext_funcs __shellrc_atexit_funcs

    unset -f shellrc-atnext shellrc-atexit shellrc-next shellrc-exit
}
