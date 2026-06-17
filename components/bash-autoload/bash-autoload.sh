# Provides zsh-like autoload functionality for bash.
# In zsh, autoload is a native builtin — this component is bash-only.
#
# Usage:
#   autoload [options] [name ...]
#
# Options (may be combined, e.g. -Uz):
#   -U    Suppress alias expansion when loading the function definition
#   -z    zsh-style autoloading (default): file content IS the function body,
#         unless it contains only a simple function definition
#   -k    ksh-style autoloading: file is sourced and must define the function
#   -t    Turn on execution tracing for the function
#   -T    Turn on execution tracing for this function only (same as -t in bash)
#   -r    Search for function now and remember path (silent if not found)
#   -R    Search for function now and remember path (error if not found)
#   -d    Allow absolute-path autoload to default to FPATH search
#   -m    With +X: treat names as patterns matching already-registered functions
#   -X    Inside a stub: load and execute with current arguments
#   +X    Load the function definition without executing it
#   +U/+k/+z/+d/+t/+T  Unset the corresponding minus option
#   +r/+R/+m  Same effect as -r/-R/-m (zsh does not toggle these off)
#
# If name is an absolute path, the function is loaded from that file and
# named after the basename. With -d, falls back to fpath if file not found.
#
# FPATH is a colon-separated list of directories to search for function files.
# The fpath array is kept in sync with FPATH via bind-var.

[[ ! -v BASH_VERSION ]] && return

# Search path for autoloadable function files (colon-separated, like PATH).
# Not exported to avoid overriding zsh's fpath in child shells.
declare -g FPATH="${FPATH:-}"
declare -ga fpath=()
bind-var FPATH fpath

# Add bundled zsh-compatible function directory to fpath
fpath+=("$(script_directory)/zsh")

# Registry of autoloaded functions — values: "undefined" (stub) or "loaded"
declare -gA __autoload_registry=()

# Per-function flags string preserved from registration
declare -gA __autoload_flags=()

# Remembered (cached) file paths for functions registered with -r/-R
declare -gA __autoload_paths=()

# Search fpath for a function file.
# $1: function name
# Prints the resolved path on success.
__autoload_find_file() {
    local name="$1" dir

    # Check cached path first
    if [[ -n "${__autoload_paths[$name]:-}" ]]; then
        if [[ -f "${__autoload_paths[$name]}" && -r "${__autoload_paths[$name]}" ]]; then
            printf '%s' "${__autoload_paths[$name]}"
            return 0
        fi
        unset '__autoload_paths[$name]'
    fi

    for dir in "${fpath[@]}"; do
        [[ -z "$dir" || ! -d "$dir" ]] && continue
        if [[ -f "$dir/$name" && -r "$dir/$name" ]]; then
            printf '%s' "$dir/$name"
            return 0
        fi
    done

    return 1
}

# Resolve the file that backs function NAME, honoring cache, fpath, and -d.
# Echoes the resolved path on stdout. Returns non-zero with a diagnostic on
# failure.
# $1: function name   $2: flags string
__autoload_resolve_path() {
    local name="$1" flags="${2:-}"

    if [[ -n "${__autoload_paths[$name]:-}" ]]; then
        local cached="${__autoload_paths[$name]}"
        if [[ -f "$cached" && -r "$cached" ]]; then
            printf '%s' "$cached"
            return 0
        fi
        # cached path stale — only fall back to fpath search with -d
        if [[ "$flags" != *d* ]]; then
            echo "autoload: $name: definition not found" >&2
            return 1
        fi
    fi

    if [[ ${#fpath[@]} -eq 0 ]]; then
        echo "autoload: $name: fpath is empty" >&2
        return 1
    fi
    if ! __autoload_find_file "$name"; then
        echo "autoload: $name: definition not found" >&2
        return 1
    fi
}

# ksh-style loader: source the file; it must define the function.
# $1: function name   $2: file path
__autoload_load_kstyle() {
    local name="$1" file="$2"
    source "$file"
    if ! declare -f "$name" >/dev/null 2>&1; then
        echo "autoload: $name: function not defined by file (ksh-style)" >&2
        return 1
    fi
}

# zsh-style loader: if file defines a function with this name, source it;
# otherwise wrap the file content as the function body. The newline before
# the closing `}` matters: it prevents a trailing `#` comment in the body
# from commenting out the brace.
# $1: function name   $2: file path
__autoload_load_zstyle() {
    local name="$1" file="$2"
    local body
    body="$(<"$file")"

    # Escape regex metacharacters in name so e.g. `foo.bar` doesn't match `fooxbar`
    local re_name
    re_name=$(printf '%s' "$name" | sed 's/[].*+?^${}()|\\[]/\\&/g')
    if grep -qE "^[[:space:]]*(function[[:space:]]+${re_name}([[:space:]]*\(\))?|${re_name}[[:space:]]*\(\))" <<< "$body" 2>/dev/null; then
        source "$file"
        declare -f "$name" >/dev/null 2>&1 && return 0
    fi
    eval -- "$(printf '%q' "$name")() { ${body:-:}
}"
}

# Load a function from its file. Orchestrates path resolution, alias-expansion
# save/restore for -U, the style-specific loader, and registry/trace bookkeeping.
# $1: function name   $2: flags string
__autoload_resolve() {
    local name="$1" flags="${2:-}"

    local file
    file=$(__autoload_resolve_path "$name" "$flags") || return 1

    [[ "$flags" == *[rR]* ]] && __autoload_paths[$name]="$file"

    unset -f "$name" 2>/dev/null || true

    local restore_aliases=false
    if [[ "$flags" == *U* ]] && shopt -q expand_aliases 2>/dev/null; then
        shopt -u expand_aliases
        restore_aliases=true
    fi

    local rc=0
    if [[ "$flags" == *k* ]]; then
        __autoload_load_kstyle "$name" "$file" || rc=$?
    else
        __autoload_load_zstyle "$name" "$file" || rc=$?
    fi

    $restore_aliases && shopt -s expand_aliases
    (( rc == 0 )) || return $rc

    [[ "$flags" == *[tT]* ]] && declare -ft "$name"
    __autoload_registry[$name]="loaded"
    return 0
}

# Register a function for autoloading.
__autoload_register() {
    local name="$1" flags="$2" load_now="$3"

    if $load_now; then
        # +X: load but don't execute; no-op if already loaded
        [[ "${__autoload_registry[$name]:-}" == "loaded" ]] && return 0
        __autoload_resolve "$name" "$flags"
    else
        __autoload_registry[$name]="undefined"
        __autoload_flags[$name]="$flags"
        eval -- "$(printf '%q' "$name")() {
            __autoload_resolve $(printf '%q' "$name") $(printf '%q' "$flags") || return \$?
            $(printf '%q' "$name") \"\$@\"
        }"
    fi
}

autoload() {
    __bound-vars-sync

    local load_now=false pattern_match=false flags=""
    local -a names=()
    local optchars ch i

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --)
                shift
                names+=("$@")
                break
                ;;
            -?*)
                optchars="${1#-}"
                for (( i = 0; i < ${#optchars}; i++ )); do
                    ch="${optchars:$i:1}"
                    case "$ch" in
                        U|z|k|t|T|r|R|d)
                            [[ "$flags" != *"$ch"* ]] && flags+="$ch"
                            ;;
                        m)
                            pattern_match=true
                            ;;
                        X)
                            local caller="${FUNCNAME[1]}"
                            if [[ -z "$caller" || "$caller" == "main" || "$caller" == "source" ]]; then
                                echo "autoload: -X must be used inside a function" >&2
                                return 1
                            fi
                            __autoload_resolve "$caller" "${__autoload_flags[$caller]:-}" || return $?
                            return 0
                            ;;
                        *)
                            echo "autoload: unknown option: -$ch" >&2
                            return 1
                            ;;
                    esac
                done
                ;;
            +?*)
                optchars="${1#+}"
                for (( i = 0; i < ${#optchars}; i++ )); do
                    ch="${optchars:$i:1}"
                    case "$ch" in
                        X) load_now=true ;;
                        # zsh toggles — cancel the corresponding minus option
                        t|T) flags="${flags//[tT]/}" ;;
                        U|k|z|d) flags="${flags//"$ch"/}" ;;
                        # zsh non-toggles — +r/+R/+m behave identically to -r/-R/-m
                        r|R) [[ "$flags" != *"$ch"* ]] && flags+="$ch" ;;
                        m) pattern_match=true ;;
                        *)
                            echo "autoload: unknown option: +$ch" >&2
                            return 1
                            ;;
                    esac
                done
                ;;
            *)
                names+=("$1")
                ;;
        esac
        shift
    done

    # -k takes precedence over -z
    [[ "$flags" == *k* ]] && flags="${flags//z/}"

    # No names — list registered autoloads
    if [[ ${#names[@]} -eq 0 ]] && ! $pattern_match; then
        (( ${#__autoload_registry[@]} == 0 )) && return 0
        local name
        while IFS= read -r name; do
            echo "autoload ${__autoload_registry[$name]} $name"
        done < <(printf '%s\n' "${!__autoload_registry[@]}" | sort)
        return 0
    fi

    # +X with -m: load already-registered functions matching patterns
    if $load_now && $pattern_match; then
        local pattern name
        for pattern in "${names[@]}"; do
            for name in "${!__autoload_registry[@]}"; do
                # shellcheck disable=SC2053
                if [[ "$name" == $pattern && "${__autoload_registry[$name]}" == "undefined" ]]; then
                    __autoload_resolve "$name" "${__autoload_flags[$name]:-$flags}" || true
                fi
            done
        done
        return 0
    fi

    # Handle absolute path names
    local -a resolved_names=()
    local name basename
    for name in "${names[@]}"; do
        if [[ "$name" == /* ]]; then
            basename="${name##*/}"
            __autoload_paths[$basename]="$name"
            resolved_names+=("$basename")
        else
            resolved_names+=("$name")
        fi
    done
    names=("${resolved_names[@]}")

    # -r: resolve path now, silent if not found
    if [[ "$flags" == *r* ]] && ! $load_now; then
        local found
        for name in "${names[@]}"; do
            [[ -z "$name" ]] && continue
            found="$(__autoload_find_file "$name")" && __autoload_paths[$name]="$found"
        done
    fi

    # -R: resolve path now, error if not found. Per-name failures don't abort
    # the rest of the list — collect the final exit code and continue.
    local rc=0
    if [[ "$flags" == *R* ]] && ! $load_now; then
        local found
        for name in "${names[@]}"; do
            [[ -z "$name" ]] && continue
            if found="$(__autoload_find_file "$name")"; then
                __autoload_paths[$name]="$found"
            else
                echo "autoload: $name: definition not found" >&2
                rc=1
            fi
        done
        (( rc == 0 )) || return $rc
    fi

    for name in "${names[@]}"; do
        [[ -z "$name" ]] && continue
        __autoload_register "$name" "$flags" "$load_now" || rc=$?
    done
    return $rc
}
