---
name: new-component
description: Scaffold a new ShellRc component. Use when asked to create, add, or scaffold a new shell component.
---

# New Component Scaffolding

Create new components for the ShellRc framework following established conventions.

## Steps

1. **Ask the user** for the component name (lowercase, hyphenated) and what it does.
2. **Ask which category** it belongs to in `shellrc.sh`:
   - Core infrastructure (loaded first, order-sensitive) — rarely needed
   - Shell setup (shell behavior, completions, aliases, prompt)
   - App config (application-specific settings — most common)
3. **Ask which optional files** are needed:
   - `install.sh` — for deploying configs during installation (symlinks, generated files)
   - `backuplist.txt` — if the component manages system paths that should be backed up

## File creation

### Entry point: `components/<name>/<name>.sh`

This is the only required file. It is sourced at shell startup.

**Patterns to follow:**

- Use `script_directory` to get the component's directory path:
  ```sh
  __mycomp_dir="$(script_directory)"
  ```
- Use `include "file.sh"` to source files relative to the component directory (never manual `source`/`.` with path construction).
- Guard interactive-only code with:
  ```sh
  [[ $- != *i* ]] && return
  ```
- For bash/zsh differences use:
  ```sh
  if [[ -v BASH_VERSION ]]; then
      # bash-specific
  elif [[ -v ZSH_VERSION ]]; then
      # zsh-specific
  fi
  ```
- Prefix internal variables/functions with `__<name>` (double underscore + component name) to avoid collisions (e.g. `__wget_dir`, `__wget-generate-wgetrc`).
- No shebang line — these are sourced files, not standalone scripts.
- For environment variable exports (e.g. pointing config to XDG paths), no interactive guard is needed.
- For aliases, completions, and prompt tweaks, use the `[[ $- != *i* ]] && return` guard.

**Simple example** (app config exporting an env var):
```sh
export WGETRC="$(script_directory)/wget.conf.gen"
```

**Example with aliases** (interactive-only):
```sh
[[ $- != *i* ]] && return
alias shellgit="git -C $SHELLRC_DIR"
```

**Example with sub-files:**
```sh
[[ $- != *i* ]] && return
include "aliases.sh"
include "keybindings.sh"
```

### Optional: `install.sh`

Sourced during `install.sh` execution. Has access to `script_directory`, `include`, and all XDG variables (`$XDG_CONFIG_HOME`, `$XDG_DATA_HOME`, etc.).

**Common patterns:**
- Symlink a config directory:
  ```sh
  dir="$(script_directory)"
  ln -sfT "$dir/config" "$XDG_CONFIG_HOME/myapp"
  ```
- Generate a config file:
  ```sh
  dir="$(script_directory)"
  mkdir -p "$XDG_CONFIG_HOME/myapp"
  printf "[include]\tpath = \"$dir/myapp.conf\"\n" >"$XDG_CONFIG_HOME/myapp/config"
  ```

### Optional: `backuplist.txt`

One path per line listing system files this component manages. These are backed up to `~/ShellRcBackups/<component>/` during install. Use shell variables like `$HOME`, `$XDG_CONFIG_HOME` in paths.

Example:
```
$XDG_CONFIG_HOME/myapp
$HOME/.myapprc
```

## Registering in `shellrc.sh`

After creating the component files, add a `load-component <name>` line to `shellrc.sh` in the appropriate section:

- **Core infrastructure** — at the top, order matters (between `load-component script-sourcing` and `load-component shellenv`)
- **Shell setup** — middle section (between `load-component shell` and `load-component shellrc`)
- **App configs** — bottom section, alphabetically sorted (between `load-component xdg` and `shellrc-exit`)

App configs are sorted alphabetically. Insert the new line in the correct position.

## Package dependencies

If the component requires packages to be installed:
- Add to `install/packages/core/packages.txt` if the package name is the same on Arch and Debian
- Add to `install/packages/core/arch.txt` or `install/packages/core/debian.txt` only if the name differs between distros

## Style rules

- 4-space indentation, UTF-8, LF line endings, trailing newline
- No shebang on sourced files
- Use `include` for relative sourcing
- Minimal comments — only where clarification is needed

## Checklist before finishing

- [ ] Component directory created: `components/<name>/`
- [ ] Entry point created: `components/<name>/<name>.sh`
- [ ] Optional files created if requested (`install.sh`, `backuplist.txt`)
- [ ] `load-component <name>` added to `shellrc.sh` in the correct section and position
- [ ] Package dependencies added if needed
