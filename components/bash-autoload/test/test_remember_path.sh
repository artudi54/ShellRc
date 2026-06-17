# Test: -r (remember path, silent) and -R (remember path, error if not found)

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' RETURN
FPATH="$tmpdir"

# --- -r remembers the resolved path ---

printf 'echo "remembered"\n' > "$tmpdir/rem_fn"
autoload -r rem_fn
rem_fn >/dev/null

# Path should be cached
local cached="${__autoload_paths[rem_fn]:-}"
assert_eq "-r caches path" "$tmpdir/rem_fn" "$cached"

# Even if FPATH changes, the cached path is used
local tmpdir2="$(mktemp -d)"
printf 'echo "wrong"\n' > "$tmpdir2/rem_fn"
FPATH="$tmpdir2"
assert_eq "-r uses cached path" "remembered" "$(rem_fn)"
FPATH="$tmpdir"
rm -rf "$tmpdir2"

# --- -r is silent if function not found at registration ---

autoload -r silent_missing 2>/dev/null; local rc=$?
assert_exit "-r silent when not found" 0 "$rc"

# --- -R errors immediately if not found ---

local out
out="$(autoload -R nonexistent_fn 2>&1)"; local rc2=$?
assert_exit "-R errors if not found" 1 "$rc2"
assert_match "-R error message" "definition not found" "$out"

# --- -R resolves and caches at registration time ---

printf 'echo "R cached"\n' > "$tmpdir/r_cached_fn"
autoload -R r_cached_fn
local cached2="${__autoload_paths[r_cached_fn]:-}"
assert_eq "-R caches path at registration" "$tmpdir/r_cached_fn" "$cached2"

# Function works
assert_eq "-R function loads correctly" "R cached" "$(r_cached_fn)"
