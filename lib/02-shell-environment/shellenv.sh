# Command for managing configuration of ShellRc

_shellenv-help() {
    if [[ "$#" -gt 0 ]]; then
        echo "shellenv: print: this command takes no arguments, $# provided" 1>&2 
        return 1
    fi
    echo "shellenv"
    echo "Usage: shellenv <command> [args]"
    echo
    echo "shellenv is command for managing ShellRc environmental configuration."
    echo "It's used internally by ShellRc component and can be used by user to"
    echo "store persistent environmental variables. Every variable is exported"
    echo "to the environment. All variables are saved in configuration file"
    echo "'$SHELLRC_ENVIRONMENT'."
    echo
    echo "Options:"
    echo "  --help - display this message"
    echo 
    echo "Supported commands:"
    echo "  get - get variable value"
    echo "  help - display this message"
    echo "  list - shows a list of all shellenv variables"
    echo "  print - print contents of configuration file"
    echo "  reload - reload variables from configuration file"
    echo "  set - set variable value"
    echo "  unset - remove variable"
    echo
}

_shellenv-print() {
    if [[ "$#" -gt 0 ]]; then
        echo "shellenv: print: this command takes no arguments, $# provided" 1>&2 
        return 1
    fi

    cat "$SHELLRC_ENVIRONMENT"
}

_shellenv-list() {
    if [[ "$#" -gt 0 ]]; then
        echo "shellenv: print: this command takes no arguments, $# provided" 1>&2 
        return 1
    fi
    
    local IFS='='
    local key
    local value
    local variables=()
    while read key value; do
        key="$(echo $key | xargs)"
        variables+=($key)
    done <"$SHELLRC_ENVIRONMENT"

    echo "${variables[@]}"
}

_shellenv-get() {
    if [[ "$#" -ne 1 ]]; then
        echo "shellenv: get: this command takes one argument, $# provided" 1>&2 
        return 1
    fi

    local key="$1"
    local line="$(grep "$key=" "$SHELLRC_ENVIRONMENT" | head -n 1)"

    if [[ -z "$line" ]]; then
        echo "shellenv: get: variable '$key' not found" 1>&2
        return 2
    fi

    local value="$(echo $line | awk -F= '{print $2}')"
    value="${value%\"}"
    value="${value#\"}"
    echo "$value"
}

_shellenv-set() {
    if [[ "$#" -ne 2 ]]; then
        echo "shellenv: set: this command takes two arguments, $# provided" 1>&2 
        return 1
    fi

    local key="$(echo "$1" | xargs)"
    local value="$2"

    eval "$key"="$value" 2>/dev/null
    if [[ "$?" -ne 0 ]]; then
        echo "shellenv: set: failed to set environmental variable '$key'"
        return 2
    fi
    export "$key"

    if grep "$key" "$SHELLRC_ENVIRONMENT" >/dev/null 2>&1; then
        sed -i "s#$key=.*#$key=\"$value\"#" "$SHELLRC_ENVIRONMENT" >/dev/null 2>&1
    else
        echo "$key=\"$value\"" >>"$SHELLRC_ENVIRONMENT" 2>/dev/null
    fi

    if [[ "$?" -ne 0 ]]; then
        echo "shellenv: set: failed to save '$key' to '$SHELLRC_ENVIRONMENT'" 1>&2
        return 2
    fi
}

_shellenv-unset() {
    if [[ "$#" -ne 1 ]]; then
        echo "shellenv: unget: this command takes one argument, $# provided" 1>&2 
        return 1
    fi
    
    local key="$(echo "$1" | xargs)"
    
    eval "unset $key" 2>/dev/null
    if [[ "$?" -ne 0 ]]; then
        echo "shellenv: unset: failed to unset environmental variable '$key'" 1>&2
        return 2
    fi

    sed -i "/$key=/d" "$SHELLRC_ENVIRONMENT" 2>/dev/null
    if [[ "$?" -ne 0 ]]; then
        echo "shellenv: unset: failed to remove '$key' from '$SHELLRC_ENVIRONMENT'" 1>&2
        return 2
    fi
}

_shellenv-reload() {
    if [[ "$#" -ne 0 ]]; then
        echo "shellenv: unget: this command takes no arguments, $# provided" 1>&2 
        return 1
    fi

    local IFS='='
    local key
    local value
    while read key value; do
        key="$(echo $key | xargs)"
        eval "$key=$value" 2>/dev/null
        if [[ "$?" -ne 0 ]]; then
            echo "shellenv: reload: failed to load environmental variable '$key'" 1>&2
        else
            export "$key"
        fi
    done <"$SHELLRC_ENVIRONMENT"
}

shellenv() {
    local comm
    if [[ "$#" -eq 0 ]]; then
        comm=print
    else
        comm="$1"
        shift
    fi

    if [[ ! -f "$SHELLRC_ENVIRONMENT" ]]; then
        echo "shellenv: file environment.conf not found" 1>&2
        return 2
    fi


    if [[ "$comm" == "--help" ]]; then
        _shellenv-help "$@"
    elif typeset -f "_shellenv-$comm" >/dev/null; then
        "_shellenv-$comm" "$@"
    else
        echo "shellenv: unknown command: '$comm'" 1>&2
        return 1
    fi

}

