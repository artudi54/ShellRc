# functions for screen profiles

screenprofile() {
    if [[ "$#" -eq 0 ]]; then
        echo "screenprofile: this command takes at least one argument, $# provided" 1>&2
        return 1
    fi

    local profile="$1"
    shift

    screen -c "$SHELLRC_DIR/components/screen/profiles/${profile}rc.sh" "$@"
}

