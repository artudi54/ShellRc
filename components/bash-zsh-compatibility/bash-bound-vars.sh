# bash-bound-vars - bidirectional sync between array and separated string variables
# Emulates zsh's `typeset -T SCALAR scalar sep` for bash using precmd hooks.
#
# Usage: bind-var SCALAR_NAME ARRAY_NAME [SEPARATOR]
#   Keeps SCALAR_NAME (separated string) and ARRAY_NAME (bash array)
#   in sync. SEPARATOR defaults to ':'.
#   Changes to either are detected and propagated on each precmd.
#   Requires bash-hooks component (precmd_functions).

if [[ -v BASH_VERSION ]]; then
    declare -ag __bound_var_scalars=()
    declare -ag __bound_var_arrays=()
    declare -ag __bound_var_seps=()

    bind-var() {
        if [[ $# -lt 2 || $# -gt 3 ]]; then
            echo "Usage: bind-var SCALAR_NAME ARRAY_NAME [SEPARATOR]" >&2
            return 1
        fi
        local scalar="$1"
        local array="$2"
        local sep="${3:-:}"

        # check if already registered — update separator if so
        local i
        for ((i = 0; i < ${#__bound_var_scalars[@]}; i++)); do
            if [[ "${__bound_var_scalars[$i]}" == "$scalar" ]]; then
                __bound_var_seps[$i]="$sep"
                # re-initialize array with new separator
                if [[ -n "${!scalar}" ]]; then
                    IFS="$sep" read -ra "$array" <<< "${!scalar}"
                else
                    declare -ga "$array=()"
                fi
                declare -g "__bound_var_last_${scalar}=${!scalar}"
                local -n arr="$array"
                local IFS="$sep"
                declare -g "__bound_var_last_${array}=${arr[*]}"
                return 0
            fi
        done

        # initialize array from scalar if scalar is set
        if [[ -n "${!scalar}" ]]; then
            IFS="$sep" read -ra "$array" <<< "${!scalar}"
        else
            declare -ga "$array=()"
        fi

        # store last-known values for change detection
        declare -g "__bound_var_last_${scalar}=${!scalar}"
        local -n arr="$array"
        local IFS="$sep"
        declare -g "__bound_var_last_${array}=${arr[*]}"

        __bound_var_scalars+=("$scalar")
        __bound_var_arrays+=("$array")
        __bound_var_seps+=("$sep")
    }

    __bound-vars-sync() {
        local i
        for ((i = 0; i < ${#__bound_var_scalars[@]}; i++)); do
            local scalar="${__bound_var_scalars[$i]}"
            local array="${__bound_var_arrays[$i]}"
            local sep="${__bound_var_seps[$i]}"
            local -n arr="$array"

            local IFS="$sep"
            local arr_as_str="${arr[*]}"
            local last_arr_var="__bound_var_last_${array}"
            local last_scalar_var="__bound_var_last_${scalar}"

            if [[ "$arr_as_str" != "${!last_arr_var}" ]]; then
                # array changed -> update scalar
                declare -g "$scalar=$arr_as_str"
            elif [[ "${!scalar}" != "${!last_scalar_var}" ]]; then
                # scalar changed -> update array
                if [[ -n "${!scalar}" ]]; then
                    IFS="$sep" read -ra "$array" <<< "${!scalar}"
                else
                    declare -ga "$array=()"
                fi
            fi

            # update last-known values
            local -n arr2="$array"
            IFS="$sep"
            declare -g "$last_arr_var=${arr2[*]}"
            declare -g "$last_scalar_var=${!scalar}"
        done
    }

    # install sync hooks
    shellrc-atnext __bound-vars-sync
    shellrc-atexit __bound-vars-sync
    [[ " ${precmd_functions[*]} " == *" __bound-vars-sync "* ]] || precmd_functions+=(__bound-vars-sync)
    # bind common variables
    bind-var PATH path
    bind-var MANPATH manpath

elif [[ -v ZSH_VERSION ]]; then
    bind-var() {
        if [[ $# -lt 2 || $# -gt 3 ]]; then
            echo "Usage: bind-var SCALAR_NAME ARRAY_NAME [SEPARATOR]" >&2
            return 1
        fi
        local scalar="$1"
        local array="$2"
        local sep="${3:-:}"

        # skip if already tied (e.g. PATH/path, CDPATH/cdpath)
        local vartype
        eval "vartype=\${(t)$array}"
        if [[ "$vartype" == *tied* ]]; then
            return 0
        fi

        typeset -gT "$scalar" "$array" "$sep"
    }
fi

