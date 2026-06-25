# AI Agent Instructions

> **Note:** `AGENTS.md` is the single source of truth. `CLAUDE.md`, `GEMINI.md`,
> and `.github/copilot-instructions.md` are **symlinks** to this file — they all
> have identical content. Do not read them separately; you already have everything.

This file provides guidance to AI coding agents when working with code in this repository.

## What this is

ShellRc is a personal shell configuration framework for bash and zsh. It organizes dotfiles, shell settings, aliases, keybindings, and application configs into modular **components** that are loaded at shell startup via `shellrc.sh`.

Supported distros: Arch, Debian 13+, Ubuntu 24.04/26.04+.

## Commands

There is no test suite or linter. Install with `./install.sh`.

### Install flow

`install.sh` runs four phases in order, sourcing helpers from `install/`:

1. `install/prepare.sh` — detects the distro (Arch family vs Debian family via `/etc/os-release` `ID`/`ID_LIKE`) and sources `install/prepare/<distro>.sh` to enable extra repos / refresh package metadata.
2. `install/packages.sh` — same distro detection, then collects packages from `install/packages/*/` and runs `pacman -Sy --needed --noconfirm` or `apt install -y`.
3. `install/backup.sh "$SHELLRC_DIR/components"` — moves any existing system files listed in each component's `backuplist.txt` into `~/ShellRcBackups/<component>/`. Aborts if `~/ShellRcBackups` already exists.
4. `install/components.sh "$SHELLRC_DIR/components"` — sources each `components/*/install.sh` to deploy configs (symlinks, generated files).

### Package lists

Packages live under `install/packages/<group>/`. Current groups:

- `core` — required CLI packages used by ShellRc components.
- `core-gui` — packages for components that require a desktop/GUI (Konsole, Yakuake, Dolphin, Ark, Wine, MediaInfo GUI). Skipped when `install.sh` is invoked with `-c` / `CORE_ONLY=1`.

Each group has up to three files:

- `packages.txt` — names that are identical on Arch and Debian → goes here, no need to duplicate.
- `arch.txt` — Arch-only names or Arch-specific aliases.
- `debian.txt` — Debian/Ubuntu-only names or Debian-specific aliases.

One package per line, blank lines ignored. `install/packages.sh` unions the shared list with the distro-specific list and dedupes via `sort -u`. **When adding a package, default to `packages.txt` and only split into per-distro files if the package name actually differs between distros.**

Pass `-c` to `install.sh` (or export `CORE_ONLY=1` beforehand) to install only the `core` group and skip any other groups (e.g., `core-gui`).

### Docker testing

Docker images are used to test installation on supported distros. All Docker-related files live in `docker/`:

- `Dockerfile` — parameterized with `SYSTEM` build arg, creates a `shelluser` with sudo, copies the repo, uses `runuser -l` in the entrypoint for a full login environment.
- `entrypoint.sh` — runs `install.sh` via `runuser -l shelluser`, then execs any additional arguments (ENTRYPOINT + CMD pattern).
- `build-image.sh` — builds an image with logging, timing, and failure output.
- `run-test.sh` — runs a container with logging, timing, and failure output.

Both helper scripts log to `$SHELLRC_CACHE_DIR/test-logs/` (falling back to `~/.cache/ShellRc/test-logs/`), preserve colors via `script -qec`, include timestamps in log filenames, and only print output on failure.

### Makefile targets

```
make install              # run install.sh on the host
make image-<distro>       # build Docker image for a distro
make images               # build all images
make test-<distro>        # build + run install in container (exit on completion)
make test                 # test all distros
```

Available distros: `arch`, `debian-13`, `ubuntu-24.04`, `ubuntu-26.04`. Aliases: `image-debian` → `debian-13`, `image-ubuntu` → `ubuntu-26.04`, `test-debian` → `debian-13`, `test-ubuntu` → `ubuntu-26.04`.

To run interactively (install + drop into shell): `docker run -it --rm artudi54/shellrc:<distro> bash --login`

## Architecture

### Entry point

`shellrc.sh` is sourced from `~/.bashrc` / zsh equivalent. It:
1. Sets `$SHELLRC_DIR` to its own directory
2. Defines `load-component <name>` which sources `components/<name>/<name>.sh`
3. Loads components in dependency order — core infrastructure first, then shell setup, then app configs

### Component convention

Each component lives in `components/<name>/` with a required entry point `<name>.sh`. Optional files:

- `install.sh` — run during installation to deploy configs (symlinks, config file generation)
- `backuplist.txt` — lists system paths this component manages (used by the backup step in install)
- Subdirectories for completions, plugins, binaries, man pages, etc.

### Core utilities (from `script-sourcing` component)

All component scripts rely on two functions loaded early:

- `script_directory` — returns the directory of the calling script (works in both bash/zsh)
- `include "file.sh"` — sources a file relative to the calling script's directory, or by absolute path

These replace manual `source`/`dirname` boilerplate. Use them in any new component.

### Key infrastructure components (loaded first, order matters)

1. **script-sourcing** — provides `include` and `script_directory` (git submodule)
2. **shellrc-hooks** — lifecycle hooks for init: `shellrc-atnext` (runs after each `load-component`), `shellrc-atexit` (runs once at end); cleaned up after init completes via `shellrc-exit`
3. **directory-setup** — bundles three sub-files:
   - `xdg-dirs.sh` — ensures all XDG base directory variables are set and directories exist
   - `shellrc-dirs.sh` — creates ShellRc-specific cache/data/state dirs under XDG paths
   - `user-bin.sh` — adds user bin directories to PATH
4. **bash-zsh-compatibility** — bundles several bash↔zsh compatibility layers:
   - `bash-hooks` — adds `chpwd`/`precmd`/`preexec` hook support to bash (zsh has these natively)
   - `bash-autoload.sh` — zsh-like `autoload` for bash, with `FPATH`/`fpath` support
   - `zsh-completion.sh` — sets up zsh completion with bash compatibility (zsh only)
5. **core-utils** — common utility functions and autoloadable function directories:
   - `functions/` — autoloadable functions for both shells (e.g. `array-append-unique`, `array-prepend-unique`, `array-print`), registered on `fpath`
   - `functions/zsh/` — bash ports of zsh autoloadable functions (`add-zsh-hook`, `colors`, `is-at-least`), added to `fpath` on bash only
   - `functions/zsh-stubs/` — no-op stubs for zsh builtins that bash doesn't need (`compinit`, `bashcompinit`, `compaudit`, `promptinit`), added to `fpath` on bash only
   - `completions/` — tab-completion definitions for the above functions
6. **completable-aliases** — overrides `alias` builtin so aliases auto-inherit command completions
7. **shellenv** — persistent environment variable management via `shellenv get/set/unset/list/reload/sync`

### Shell compatibility pattern

Components that differ between bash and zsh use this pattern:
```sh
if [[ -v BASH_VERSION ]]; then
    # bash-specific code
elif [[ -v ZSH_VERSION ]]; then
    # zsh-specific code
fi
```

Interactive-only code is guarded with: `[[ $- != *i* ]] && return`

### Git submodules

Several components include third-party tools as submodules (bash-completion, zsh-completions, zsh-syntax-highlighting, git-flow-next, git-extras, complete-alias, lesspipe, vim plugins, paki). Run `git submodule update --init --recursive` after cloning.

## Style

- 4-space indentation, UTF-8, LF line endings, trailing newline (see `.editorconfig`)
- Shell scripts use `#!/usr/bin/env bash` shebangs for standalone scripts; sourced files have no shebang
- Use `include` for relative sourcing, not manual `source`/`.` with path construction

