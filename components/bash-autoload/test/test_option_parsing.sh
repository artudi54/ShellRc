# Test: option parsing — combined flags, --, errors

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' RETURN
FPATH="$tmpdir"

printf 'echo "opt ok"\n' > "$tmpdir/opt_fn"

# --- combined minus flags ---

printf 'echo "c1"\n' > "$tmpdir/combo1"
autoload -Uz combo1
assert_eq "-Uz combined" "c1" "$(combo1)"

printf 'echo "c2"\n' > "$tmpdir/combo2"
autoload -zU combo2
assert_eq "-zU reversed" "c2" "$(combo2)"

printf 'echo "c3"\n' > "$tmpdir/combo3"
autoload -Uzt combo3
assert_eq "-Uzt all combined" "c3" "$(combo3)"

# --- +X flag ---

printf 'echo "px"\n' > "$tmpdir/plus_x"
autoload +X plus_x
assert_eq "+X works" "px" "$(plus_x)"

# --- -- stops option parsing ---

printf '  echo "dash dash"\n' > "$tmpdir/-weird"
autoload -- -weird
assert_eq "-- allows dash-prefixed names" "dash dash" "$(-weird)"

# --- unknown - option ---

local out
out="$(autoload -q test_fn 2>&1)"; local rc=$?
assert_exit "unknown -option errors" 1 "$rc"
assert_match "unknown -option message" "unknown option: -q" "$out"

# --- unknown + option ---

local out2
out2="$(autoload +q test_fn 2>&1)"; local rc2=$?
assert_exit "unknown +option errors" 1 "$rc2"
assert_match "unknown +option message" "unknown option: \\+q" "$out2"

# --- unknown flag in combined string ---

local out3
out3="$(autoload -Uq test_fn 2>&1)"; local rc3=$?
assert_exit "unknown flag in combo errors" 1 "$rc3"
assert_match "unknown flag in combo message" "unknown option: -q" "$out3"

# --- listing with no args ---

printf 'echo "la"\n' > "$tmpdir/list_a"
printf 'echo "lb"\n' > "$tmpdir/list_b"
autoload list_a list_b
local listing
listing="$(autoload)"
assert_match "listing shows list_a" "list_a" "$listing"
assert_match "listing shows list_b" "list_b" "$listing"
assert_match "listing shows undefined" "undefined" "$listing"

# --- listing after load ---

list_a >/dev/null
listing="$(autoload)"
assert_match "listing shows loaded after call" "loaded list_a" "$listing"
