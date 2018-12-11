# basic repository variables
if [ -n "$ZSH_VERSION" ]; then
    export SHELLRC_DIR=$(dirname "${(%):-%N}")
elif [ -n "$BASH_VERSION" ]; then
    export SHELLRC_DIR=$(dirname "$BASH_SOURCE")
fi

export SHELLHISTORY_DIR="$HOME/.config/ShellRc"
if [[ ! -d "$SHELLHISTORY_DIR" ]]; then
    mkdir "$SHELLHISTORY_DIR"
fi

# common hitory variables
HISTSIZE=5000
HISTFILESIZE=5000
SAVEHIST=5000

# for python
export PYTHONSTARTUP="$SHELLRC_DIR/python/pythonrc.py"

# for vim
export VIMINIT="let \$MYVIMRC='\$SHELLRC_DIR/vim/vimrc.vim' | source \$MYVIMRC"

# for screen
export SCREENRC="$SHELLRC_DIR/screen/rc/screenrc.sh"

# path additions
export PATH="$PATH:$HOME/.local/bin"

