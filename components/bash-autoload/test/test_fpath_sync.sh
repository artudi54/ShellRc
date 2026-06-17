# Test: fpath array ↔ FPATH scalar bidirectional sync

tmpdir1="$(mktemp -d)"
tmpdir2="$(mktemp -d)"
trap 'rm -rf "$tmpdir1" "$tmpdir2"' RETURN

# --- Setting FPATH populates fpath array ---

FPATH="$tmpdir1:$tmpdir2"
__bound-vars-sync
assert_eq "FPATH→fpath: first element" "$tmpdir1" "${fpath[0]}"
assert_eq "FPATH→fpath: second element" "$tmpdir2" "${fpath[1]}"
assert_eq "FPATH→fpath: count" "2" "${#fpath[@]}"

# --- Appending to fpath updates FPATH ---

local tmpdir3="$(mktemp -d)"
fpath+=("$tmpdir3")
__bound-vars-sync
assert_match "fpath→FPATH: contains new dir" "$tmpdir3" "$FPATH"

# --- autoload finds function via fpath array ---

printf 'echo "found via fpath"\n' > "$tmpdir1/fpath_fn"
fpath=("$tmpdir1")
autoload fpath_fn
assert_eq "autoload uses fpath array" "found via fpath" "$(fpath_fn)"

# --- autoload finds function after fpath+=() ---

printf 'echo "appended dir"\n' > "$tmpdir2/appended_fn"
fpath+=("$tmpdir2")
autoload appended_fn
assert_eq "autoload after fpath+=()" "appended dir" "$(appended_fn)"

# --- Modifying FPATH directly works too ---

printf 'echo "scalar path"\n' > "$tmpdir3/scalar_fn"
FPATH="$tmpdir3"
autoload scalar_fn
assert_eq "autoload after FPATH= assignment" "scalar path" "$(scalar_fn)"

# --- fpath reflects FPATH change after autoload sync ---

assert_eq "fpath synced from FPATH" "$tmpdir3" "${fpath[0]}"
assert_eq "fpath has one element" "1" "${#fpath[@]}"

# --- Empty fpath produces error ---

fpath=()
FPATH=""
autoload empty_test 2>/dev/null
local out
out="$(empty_test 2>&1)"; local rc=$?
assert_exit "empty fpath errors" 1 "$rc"

rm -rf "$tmpdir3"
