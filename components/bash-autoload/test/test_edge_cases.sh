# Test: edge cases and interactions between flags

tmpdir="$(mktemp -d)"
mkdir -p "$tmpdir/sub"
trap 'rm -rf "$tmpdir"' RETURN
FPATH="$tmpdir"

# --- autoloading the same function twice overwrites stub ---

printf 'echo "v1"\n' > "$tmpdir/overwrite_fn"
autoload overwrite_fn
printf 'echo "v2"\n' > "$tmpdir/overwrite_fn"
autoload overwrite_fn
assert_eq "re-autoload uses latest file" "v2" "$(overwrite_fn)"

# --- ksh-style file with helper functions ---

printf 'helper_internal() { echo "helper"; }\nmain_fn() { helper_internal; echo "main: $1"; }\n' > "$tmpdir/main_fn"
autoload -k main_fn
local out
out="$(main_fn test)"
assert_eq "ksh file with helpers loads all" "$(printf 'helper\nmain: test')" "$out"

# --- body-only file with conditional logic ---

printf 'if [[ "$1" == "yes" ]]; then\n    echo "affirm"\nelse\n    echo "deny"\nfi\n' > "$tmpdir/cond_fn"
autoload cond_fn
assert_eq "body-only conditional: yes" "affirm" "$(cond_fn yes)"
assert_eq "body-only conditional: no" "deny" "$(cond_fn no)"

# --- ksh-style function that sources another file ---

printf 'echo "sourced_helper"\n' > "$tmpdir/helper_file.sh"
printf 'sourcing_fn() { source "%s/helper_file.sh"; echo "main"; }\n' "$tmpdir" > "$tmpdir/sourcing_fn"
autoload -k sourcing_fn
out="$(sourcing_fn)"
assert_eq "ksh function sourcing other files" "$(printf 'sourced_helper\nmain')" "$out"

# --- -r with ksh-style remembers path ---

printf 'rem_ksh() { echo "rk"; }\n' > "$tmpdir/rem_ksh"
autoload -rk +X rem_ksh
assert_eq "-rk function loads" "rk" "$(rem_ksh)"
local cached="${__autoload_paths[rem_ksh]:-}"
assert_eq "-rk caches path" "$tmpdir/rem_ksh" "$cached"

# --- empty function file ---

> "$tmpdir/empty_fn"
autoload empty_fn
local out2
out2="$(empty_fn 2>&1)"
# Should either work (empty body → :) or error, but not crash
assert_exit "empty file does not crash" 0 "$?"

# --- function with lots of arguments ---

printf 'echo "$#"\n' > "$tmpdir/many_args"
autoload many_args
assert_eq "many arguments passed through" "10" "$(many_args a b c d e f g h i j)"

# --- nested autoload (autoloaded function triggers another autoload) ---

printf 'echo "inner: $1"\n' > "$tmpdir/inner"
printf 'autoload inner; inner "$1"; echo "outer: $1"\n' > "$tmpdir/outer"
autoload outer
out="$(outer test)"
assert_eq "nested autoload works" "$(printf 'inner: test\nouter: test')" "$out"
