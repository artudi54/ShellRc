# Test: +k, +t, +z toggle flags off

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' RETURN
FPATH="$tmpdir"

# --- +k unsets ksh-style (reverts to zsh body-wrapping) ---

printf 'echo "body mode"\n' > "$tmpdir/toggle_k"
autoload -k +k toggle_k
# +k cancels -k, so it should body-wrap (zsh-style)
assert_eq "+k cancels -k" "body mode" "$(toggle_k)"

# --- +z unsets zsh-style (but without -k it's still default zsh) ---

printf 'echo "still body"\n' > "$tmpdir/toggle_z"
autoload -z +z toggle_z
# +z cancels -z flag, but default behavior is still body-wrap
assert_eq "+z: still works as body" "still body" "$(toggle_z)"

# --- +t unsets trace ---

printf 'echo "no trace"\n' > "$tmpdir/toggle_t"
autoload -t +t +X toggle_t
# +t should cancel -t, so no trace attribute
local decl
decl="$(declare -pF toggle_t 2>&1 || true)"
# Should NOT show -ft (just -f means no trace)
assert_match "+t cancels -t" "declare -f toggle_t" "$decl"
assert_eq "+t function runs" "no trace" "$(toggle_t)"
