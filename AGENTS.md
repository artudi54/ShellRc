# AI Agent Instructions

> **Note:** `AGENTS.md` is the single source of truth. `CLAUDE.md`, `GEMINI.md`,
> and `.github/copilot-instructions.md` are **symlinks** to this file — they all
> have identical content. Do not read them separately; you already have everything.

This file provides guidance to AI coding agents when working with code in this repository.

## What this is

ShellRc is a personal shell configuration framework for bash and zsh. It organizes dotfiles, shell settings, aliases, keybindings, and application configs into modular **components** that are loaded at shell startup via `shellrc.sh`.

Supported distros: Arch, Debian 13+, Ubuntu 24.04/26.04+.

## Commands

There is no test suite or linter. Install with `bash install.sh`. The install script
works but is widely untested. Makefile and Docker images are under construction.

### Install flow

`install.sh` runs four phases in order, sourcing helpers from `install/`:

1. `install/prepare.sh` — detects the distro (Arch family vs Debian family via `/etc/os-release` `ID`/`ID_LIKE`) and sources `install/prepare/<distro>.sh` to enable extra repos / refresh package metadata.
2. `install/packages.sh` — same distro detection, then collects packages from `install/packages/*/` and runs `pacman -Sy --needed --noconfirm` or `apt install -y`.
3. `install/backup.sh "$SHELLRC_DIR/components"` — moves any existing system files listed in each component's `backuplist.txt` into `~/ShellRcBackups/<component>/`. Aborts if `~/ShellRcBackups` already exists.
4. `install/components.sh "$SHELLRC_DIR/components"` — sources each `components/*/install.sh` to deploy configs (symlinks, generated files).

### Package lists

Packages live under `install/packages/<group>/` (currently only `core`). Each group has up to three files:

- `packages.txt` — names that are identical on Arch and Debian → goes here, no need to duplicate.
- `arch.txt` — Arch-only names or Arch-specific aliases.
- `debian.txt` — Debian/Ubuntu-only names or Debian-specific aliases.

One package per line, blank lines ignored. `install/packages.sh` unions the shared list with the distro-specific list and dedupes via `sort -u`. **When adding a package, default to `packages.txt` and only split into per-distro files if the package name actually differs between distros.**

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
   - `zsh-completion.sh` — sets up zsh completion with bash compatibility
   - `add-zsh-hook` — autoloadable bash port of zsh's `add-zsh-hook` (manages hook function arrays)
5. **core-utils** — common utility functions
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

