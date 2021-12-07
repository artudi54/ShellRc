# ShellRC
Personal configuration files and utilities.


## Supported Distributions
- Arch Linux
- Rocky Linux 8
- Debian 10+
- Fedora 31+
- KDE Neon
- Linux Mint 19+
- Manjaro latest
- Ubuntu and it's flavours 18.04, 19.04+

ShellRc may work on other similar distributions but it isn't guaranteed.

prequisites:
sudo, which


## Configuration steps
This section describes in detail how everything is configured and provides some documentation for source code.

### Setting up `SHELLRC_DIR`
The very first thing the setup does is to store it's location in environmental variable. It is later on used in other places.

### Loading required scripting utilities
File `lib/script-sourcing.sh` is loaded to provide with necessary utility functions for including source files.

It provides two functions:
- `script-directory` - returns the directory where current script file is located
- `include` - sources file relative to the calling script file location

This is the only occurence of `source` command in this codebase. All other script inclusions are done with `include` function. This utility is very important for the whole project, as it provides high level file import mechnism very similar to C/C++ includes.
