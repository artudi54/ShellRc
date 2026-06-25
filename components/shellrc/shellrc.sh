alias shellgit="git -C $SHELLRC_DIR"
alias shellrc="cd $SHELLRC_DIR"

# ':'-separated list of hosts targeted by `shellhosts-update`, with a
# companion array `shellrc_hosts` kept in sync (PATH/path style).
# Persisted via shellenv so assignments survive across shell sessions.
[[ -z "${SHELLRC_HOSTS+x}" ]] && export SHELLRC_HOSTS=""
bind-var SHELLRC_HOSTS shellrc_hosts
shellenv sync SHELLRC_HOSTS

# Run `shellgit pull` over SSH on every host in shellrc_hosts.
# `bash -ic` is used so each remote loads its interactive rc files (where
# the `shellgit` alias is defined by ShellRc) before running the command.
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
        echo "==> $host: shellgit pull"
        ssh -T -o BatchMode=no "$host" "bash -ic 'shellgit pull'"
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
