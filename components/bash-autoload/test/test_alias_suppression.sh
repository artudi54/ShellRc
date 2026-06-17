# Test: -U (alias suppression) flag

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"; unalias myalias 2>/dev/null; true' RETURN
FPATH="$tmpdir"

# --- -U suppresses alias expansion during load ---

printf 'myalias; echo "ran real"\n' > "$tmpdir/with_u"
printf 'myalias; echo "ran real"\n' > "$tmpdir/no_u"

# Create a command that myalias will shadow
printf '#!/usr/bin/env bash\necho "real_command"\n' > "$tmpdir/myalias"
chmod +x "$tmpdir/myalias"
local saved_path="$PATH"
PATH="$tmpdir:$PATH"

autoload -U with_u
autoload no_u

shopt -s expand_aliases
alias myalias="echo ALIASED"

local out_u out_no
out_u="$(with_u 2>&1)"
out_no="$(no_u 2>&1)"

assert_match "-U: alias NOT expanded" "real_command" "$out_u"
assert_match "no -U: alias IS expanded" "ALIASED" "$out_no"

unalias myalias 2>/dev/null
PATH="$saved_path"

# --- -U combined with other flags ---

printf 'echo "combo ok"\n' > "$tmpdir/combo_u"
autoload -Uz combo_u
assert_eq "-Uz combined works" "combo ok" "$(combo_u)"
