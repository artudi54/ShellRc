# ShellRc

Personal shell configuration framework for **bash** and **zsh** — dotfiles, aliases, keybindings, completions, prompts and per-app configs organised as small, composable **components** that are loaded at shell startup by `shellrc.sh`.

## Supported Distributions

- Arch Linux (and Arch-likes: Manjaro, EndeavourOS)
- Debian 13+
- Ubuntu 24.04, 26.04+

Other Debian- or Arch-derived distros may work but are not guaranteed.

**Prerequisites:** `sudo`, `git`, working internet access. Everything else is installed by the installer.

## Installation

```sh
git clone --recurse-submodules https://github.com/artudi54/ShellRc.git ~/.config/ShellRc
cd ~/.config/ShellRc
./install.sh
```

If you forgot `--recurse-submodules`:

```sh
git submodule update --init --recursive
```

### Install options

`install.sh` accepts:

| Flag        | Effect                                                                 |
| ----------- | ---------------------------------------------------------------------- |
| `-n <name>` | Git `user.name` (skips the interactive prompt)                         |
| `-e <mail>` | Git `user.email` (skips the interactive prompt)                        |
| `-c`        | **Core only** — install just the CLI packages (`CORE_ONLY=1`); skips the `core-gui` group (Konsole, Yakuake, Dolphin, Ark, Wine, MediaInfo GUI). Useful on headless machines / servers. |

The installer runs four phases:

1. **prepare** — enables extra repos (snap, flatpak, non-free on Debian, PPAs on Ubuntu) and refreshes package metadata.
2. **packages** — installs everything listed under `install/packages/*/` via `pacman` or `apt`.
3. **backup** — moves any existing user dotfiles that ShellRc manages into `~/ShellRcBackups/`. Aborts if that directory already exists.
4. **components** — sources each `components/*/install.sh` to deploy configs (symlinks, generated files, plugin builds).

## What you get

- Sensible bash/zsh defaults shared between both shells (history, key bindings, globbing, `cdpath`, `command-not-found`).
- Themable prompt via `shellprompt` (e.g. `shellprompt set <theme>`).
- Persistent environment variables via `shellenv get/set/sync/unset/list`.
- Big completion stack: bash-completion, zsh-completions, alias completion via `complete-alias`, plus optional syntax highlighting (`ble.sh` / `zsh-syntax-highlighting`).
- App configs preset for `git`, `vim`, `emacs`, `tmux`, `screen`, `less` (with lesspipe), `wget`, `npm`, `python`, `fastfetch`, `mediainfo`, plus GUI apps (`konsole`, `yakuake`, `dolphin`, `ark`, `wine`) when not installing core-only.
- `git`/`shellgit` workflow helpers (`shellgit` = `git -C $SHELLRC_DIR`, `shellrc` = `cd $SHELLRC_DIR`, `shellhosts-update` to fan-out `git pull` to multiple hosts).

## Testing in Docker

Each supported distro has a Docker image used to validate the installer end-to-end:

```sh
make test                 # install on every supported distro
make test-arch            # one distro
make image-ubuntu         # build the image without running install
```

Aliases: `image-debian` → `debian-13`, `image-ubuntu` → `ubuntu-26.04`, same for `test-*`.

To poke around interactively:

```sh
docker run -it --rm artudi54/shellrc:<distro> bash --login
```

Logs from `make test-*` land in `$SHELLRC_CACHE_DIR/test-logs/` (fallback `~/.cache/ShellRc/test-logs/`).

## Repository layout

```
shellrc.sh                # entry point sourced by ~/.bashrc / ZDOTDIR/.zshrc
install.sh                # top-level installer
install/                  # installer phases + package lists per group
components/               # one directory per feature (see AGENTS.md)
docker/                   # Dockerfiles + helper scripts for CI-style testing
Makefile                  # install / image-* / test-* targets
```

See [`AGENTS.md`](AGENTS.md) for a deeper architectural tour (component conventions, infrastructure load order, `script_directory` / `include` helpers, bash↔zsh compatibility patterns).

## Adding a component

1. Create `components/<name>/`.
2. Drop a `<name>.sh` for runtime setup (optional — purely declarative components can skip it).
3. Add an `install.sh` if anything needs to be wired up at install time (symlinks, plugin builds).
4. List managed system paths in `backuplist.txt` so they get backed up before the install overwrites them.
5. Register the component in the appropriate section of `shellrc.sh`.

Conventions:

- Use `include "file.sh"` and `script_directory` instead of manual `source`/`dirname` plumbing.
- Guard interactive-only code with `[[ $- != *i* ]] && return`.
- Branch on `$BASH_VERSION` / `$ZSH_VERSION` when behavior must differ.
- 4-space indentation, LF line endings, trailing newline (see `.editorconfig`).

