alias shellgit="git -C $SHELLRC_DIR"
alias shellrc="cd $SHELLRC_DIR"

# ':'-separated list of hosts targeted by `shellhosts-update`, with a
# companion array `shellrc_hosts` kept in sync (PATH/path style).
# Persisted via shellenv so assignments survive across shell sessions.
[[ -z "${SHELLRC_HOSTS+x}" ]] && export SHELLRC_HOSTS=""
bind-var SHELLRC_HOSTS shellrc_hosts
shellenv sync SHELLRC_HOSTS

# Run `git -C "$SHELLRC_DIR" pull` (i.e. the `shellgit pull` alias) over
# SSH on every host in shellrc_hosts. We avoid `bash -l` (it tries to
# grab job control over the missing tty and prints
# "no job control in this shell" warnings) and instead source ~/.profile
# manually inside a non-interactive shell to pick up SHELLRC_DIR.
shellhosts-update() {
    if [[ "$#" -gt 0 ]]; then
        echo "shellhosts-update: this command takes no arguments, $# provided" 1>&2
        return 1
    fi

    if [[ "${#shellrc_hosts[@]}" -eq 0 ]]; then
        echo "shellhosts-update: SHELLRC_HOSTS is empty" 1>&2
        echo "shellhosts-update: set it with: SHELLRC_HOSTS=\"user@host1:host2\"" 1>&2
        return 1
    fi

    local host rc failures=0
    for host in "${shellrc_hosts[@]}"; do
        [[ -z "$host" ]] && continue
        echo "==> $host: git -C \$SHELLRC_DIR pull && git -C \$SHELLRC_DIR submodule update"
        ssh -T "$host" 'bash -c ". ~/.profile; git -C \"\$SHELLRC_DIR\" pull && git -C \"\$SHELLRC_DIR\" submodule update"'
        rc=$?
        if [[ "$rc" -ne 0 ]]; then
            echo "shellhosts-update: '$host' failed (exit $rc)" 1>&2
            failures=$((failures + 1))
        fi
    done

    if [[ "$failures" -gt 0 ]]; then
        echo "shellhosts-update: $failures host(s) failed" 1>&2
        return 1
    fi
}
