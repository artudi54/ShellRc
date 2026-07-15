# XDG cleanups: point programs at XDG Base Directory paths and expose
# XDG-friendly wrapper binaries for installed apps.

# environment variable overrides for a clean home directory
include "environment-overrides.sh"

# lib/ wrapper executables on PATH and lib/desktop/ entries in the
# applications dir for installed apps, reconciled on every source
include "binary-overrides.sh"
