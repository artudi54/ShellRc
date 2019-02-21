# functions for managing configuration

shellrc-conf() {
    cat "$SHELLRC_DIR/settings.conf"
}

shellrc-conf-get() {
    if [ "$#" -ne 1 ]; then
        echo "shellrc-conf: invalid number of arguments" 1>&2
        return 1
    fi

    local key="$1"
    local value="$(grep "$key=" "$SHELLRC_DIR/settings.conf" | head -n 1 | awk -F= '{print $2}')"
    value="${value%\"}"
    value="${value#\"}"
    echo "$value"
}

shellrc-conf-set() {
    if [ "$#" -ne 2 ]; then
        echo "shellrc-conf: invalid number of arguments" 1>&2
        return 1
    fi

    local key="$1"
    local value="$2"
    
    if grep "$key" "$SHELLRC_DIR/settings.conf" >/dev/null 2>&1; then
        sed -i "s#$key=.*#$key=\"$value\"#" "$SHELLRC_DIR/settings.conf" >/dev/null 2>&1
    else
        echo "$key=\"$value\"" >>"$SHELLRC_DIR/settings.conf"
    fi
}

shellrc-conf-unset() {
    if [ "$#" -ne 1 ]; then
        echo "shellrc-conf: invalid number of arguments" 1>&2
        return 1
    fi
    
    local key="$1"
    sed -i "/$key=/d" "$SHELLRC_DIR/settings.conf"
}