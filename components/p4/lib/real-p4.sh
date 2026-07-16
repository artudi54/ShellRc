find-real-p4() {
    local bindir dir filtered=()
    bindir="$(readlink -f "$(dirname "$0")")"
    local IFS=:
    for dir in $PATH; do
        [[ "$(readlink -f "$dir" 2>/dev/null)" == "$bindir" ]] && continue
        filtered+=("$dir")
    done
    PATH="${filtered[*]}" which p4 2>/dev/null
}

