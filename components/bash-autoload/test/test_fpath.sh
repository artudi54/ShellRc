# Test: FPATH handling — multiple directories, ordering, missing dirs

tmpdir1="$(mktemp -d)"
tmpdir2="$(mktemp -d)"
trap 'rm -rf "$tmpdir1" "$tmpdir2"' RETURN

# --- first match wins ---

printf 'echo "from dir1"\n' > "$tmpdir1/priority"
printf 'echo "from dir2"\n' > "$tmpdir2/priority"
FPATH="$tmpdir1:$tmpdir2"
autoload priority
assert_eq "first FPATH dir wins" "from dir1" "$(priority)"

# --- second dir searched if not in first ---

printf 'echo "found in dir2"\n' > "$tmpdir2/onlyin2"
autoload onlyin2
assert_eq "falls through to second dir" "found in dir2" "$(onlyin2)"

# --- empty FPATH ---

local saved_fpath="$FPATH"
FPATH=""
autoload empty_fpath_fn 2>/dev/null
local out
out="$(empty_fpath_fn 2>&1)"; local rc=$?
assert_exit "empty FPATH returns error" 1 "$rc"
assert_match "empty FPATH error message" "fpath is empty" "$out"
FPATH="$saved_fpath"

# --- nonexistent directory in FPATH is skipped ---

FPATH="/nonexistent/path:$tmpdir1"
printf 'echo "skipped bad dir"\n' > "$tmpdir1/skipbad"
autoload skipbad
assert_eq "nonexistent FPATH dir is skipped" "skipped bad dir" "$(skipbad)"
FPATH="$saved_fpath"

# --- function not found anywhere ---

FPATH="$tmpdir1:$tmpdir2"
autoload totally_missing 2>/dev/null
local out2
out2="$(totally_missing 2>&1)"; local rc2=$?
assert_exit "missing function returns error" 1 "$rc2"
assert_match "missing function error message" "definition not found" "$out2"

# --- FPATH with trailing colon ---

FPATH="$tmpdir1:"
printf 'echo "trailing ok"\n' > "$tmpdir1/trailing"
autoload trailing
assert_eq "trailing colon in FPATH handled" "trailing ok" "$(trailing)"

# --- FPATH with leading colon ---

FPATH=":$tmpdir1"
printf 'echo "leading ok"\n' > "$tmpdir1/leading"
autoload leading
assert_eq "leading colon in FPATH handled" "leading ok" "$(leading)"

# --- FPATH with double colon ---

FPATH="$tmpdir1::$tmpdir2"
printf 'echo "double colon ok"\n' > "$tmpdir1/dblcolon"
autoload dblcolon
assert_eq "double colon in FPATH handled" "double colon ok" "$(dblcolon)"
