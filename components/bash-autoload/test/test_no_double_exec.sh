# Test: body-only file side effects are not duplicated during format detection

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' RETURN
FPATH="$tmpdir"

# --- body-only file with external side effect (file write) ---

local counter_file="$tmpdir/.counter"
echo "0" > "$counter_file"

# This body-only function increments a counter file on each call
printf 'local c=$(<"%s")\necho $(( c + 1 )) > "%s"\necho "count: $(( c + 1 ))"\n' \
    "$counter_file" "$counter_file" > "$tmpdir/side_effect_fn"

autoload side_effect_fn
side_effect_fn >/dev/null

local count
count="$(<"$counter_file")"
assert_eq "body-only side effect runs exactly once" "1" "$count"

# Second call should increment to 2
side_effect_fn >/dev/null
count="$(<"$counter_file")"
assert_eq "second call increments to 2" "2" "$count"
