# shellrc-atexit component
# Provides shellrc-atexit (register callbacks) and shellrc-exit (run & clear callbacks)
# Safe to source in both bash and zsh; intended to be loaded early so other
# components can register callbacks during initialization.

# Initialize array if not already present
if [[ -z "${__shellrc_atexit_funcs+x}" ]]; then
    declare -a __shellrc_atexit_funcs=()
fi

# Register one or more function names to run at shellrc exit.
# Usage: shellrc-atexit fn1 [fn2 ...]
shellrc-atexit() {
    if [[ "$#" -lt 1 ]]; then
        echo "shellrc-atexit: requires at least one function name" 1>&2
        return 1
    fi

    local fn
    for fn in "$@"; do
        # ignore empty names
        [[ -z "$fn" ]] && continue
        __shellrc_atexit_funcs+=("$fn")
    done
}

# Execute all registered callbacks in registration order and then remove them.
# Missing functions are skipped. After running, the callback list is cleared
# and the array variable is unset to avoid leaking state.
shellrc-exit() {
    local fn
    for fn in "${__shellrc_atexit_funcs[@]:-}"; do
        [[ -z "$fn" ]] && continue
        if declare -f "$fn" >/dev/null 2>&1; then
            "$fn"
        fi
    done

    # Clear and remove the list of callbacks
    __shellrc_atexit_funcs=()
    unset __shellrc_atexit_funcs

    # Remove registration functions to avoid polluting the global namespace
    unset -f shellrc-atexit shellrc-exit
}
