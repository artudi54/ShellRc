#!/usr/bin/env bash
set -e
PACKAGES_DIR="$(script_directory)/packages"

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

collect_packages() {
    local distro="$1"
    local packages=()

    for dir in "$PACKAGES_DIR"/*/; do
        [[ -d "$dir" ]] || continue

        if [[ -f "$dir/packages.txt" ]]; then
            mapfile -t lines < <(grep -v '^\s*$' "$dir/packages.txt")
            packages+=("${lines[@]}")
        fi

        if [[ -f "$dir/$distro.txt" ]]; then
            mapfile -t lines < <(grep -v '^\s*$' "$dir/$distro.txt")
            packages+=("${lines[@]}")
        fi
    done

    printf '%s\n' "${packages[@]}" | sort -u
}

install_debian() {
    local packages
    mapfile -t packages < <(collect_packages "debian")
    echo "Installing ${#packages[@]} packages with apt..."
    sudo apt update
    sudo apt install -y "${packages[@]}"
}

install_arch() {
    local packages
    mapfile -t packages < <(collect_packages "arch")
    echo "Installing ${#packages[@]} packages with pacman..."
    sudo pacman -Sy --needed --noconfirm "${packages[@]}"
}

distro="$(detect_distro)"

case "$distro" in
    debian)
        install_debian
        ;;
    arch)
        install_arch
        ;;
    *)
        echo "packages.sh: unsupported distribution" >&2
        exit 1
        ;;
esac

# Re-source profile.d scripts to pick up PATH changes from newly installed
# packages (e.g. Arch's perlbin.sh adds /usr/bin/core_perl to PATH)
for profile_script in /etc/profile.d/*.sh; do
    [[ -r "$profile_script" ]] && source "$profile_script"
done
unset profile_script
