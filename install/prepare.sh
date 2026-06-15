#!/usr/bin/env bash
set -e
PREPARE_DIR="$(script_directory)/prepare"

detect_distro() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        case "$ID" in
            debian|ubuntu|linuxmint|pop)
                echo "debian"; return ;;
            arch|manjaro|endeavouros)
                echo "arch"; return ;;
        esac
        for like in $ID_LIKE; do
            case "$like" in
                debian|ubuntu)
                    echo "debian"; return ;;
                arch)
                    echo "arch"; return ;;
            esac
        done
    fi
    echo "unknown"
}

distro="$(detect_distro)"

case "$distro" in
    debian)
        include "$PREPARE_DIR/debian.sh"
        ;;
    arch)
        include "$PREPARE_DIR/arch.sh"
        ;;
    *)
        echo "prepare.sh: unsupported distribution" >&2
        exit 1
        ;;
esac
