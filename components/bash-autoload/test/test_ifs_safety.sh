# Test: IFS safety — sourced files and body-only evals must not see IFS=':'

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' RETURN
FPATH="$tmpdir"

# --- ksh-style function-definition file using word splitting ---

printf 'ifs_def() {\n    local input="$1"\n    local -a words=($input)\n    echo "${#words[@]}"\n}\n' > "$tmpdir/ifs_def"
autoload -k ifs_def
assert_eq "IFS safe: ksh-style word split" "3" "$(ifs_def "a b c")"

# --- body-only file using word splitting ---

printf 'local input="$1"\nlocal -a words=($input)\necho "${#words[@]}"\n' > "$tmpdir/ifs_body"
autoload ifs_body
assert_eq "IFS safe: body-only word split" "3" "$(ifs_body "a b c")"

# --- ksh-style function using IFS explicitly ---

printf 'ifs_custom() {\n    local IFS=","\n    local -a parts=($1)\n    echo "${#parts[@]}"\n}\n' > "$tmpdir/ifs_custom"
autoload -k ifs_custom
assert_eq "IFS safe: custom IFS in func" "3" "$(ifs_custom "a,b,c")"

# --- colons in function arguments should not be split ---

printf 'echo "$1"\n' > "$tmpdir/ifs_colon"
autoload ifs_colon
assert_eq "IFS safe: colons in args preserved" "a:b:c" "$(ifs_colon "a:b:c")"

# --- FPATH with spaces in directory path ---

local space_dir="$tmpdir/dir with spaces"
mkdir -p "$space_dir"
printf 'echo "spaces ok"\n' > "$space_dir/space_fn"
FPATH="$space_dir"
autoload space_fn
assert_eq "FPATH with spaces works" "spaces ok" "$(space_fn)"
FPATH="$tmpdir"
