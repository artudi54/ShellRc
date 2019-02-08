source $SHELLRC_DIR/functions/*.sh

# function for listing directories only
# TODO: FIX
ld() {
    local IFS=$'\n' 
	local files=$(ls -l $@ | grep "^d\|^l" | awk '{print $9}')
    local directories=""
    for file in $files; do 
        if [[ -d "$file" ]] || [[ -d "$(readlink -- "$file")" ]]; then
            directories="${directories}"$'\n'"${file}"
        fi
    done
    ls -d $@ $directories
}

alias ldl='ld -l'

# path show
pathshow() {
	echo -e ${PATH//:/\\n}
}
# quick add to path
pathadd() {
	if [ $# -ne 0 ]; then
		export PATH=$PATH:$@
	else
		echo "No path specified"
	fi
}

# unpack archives    
extract () {
	if [ -f $1 ] ; then
		case $1 in
		*.tar.bz2)   tar xjf $1        ;;
		*.tar.gz)    tar xzf $1     ;;
		*.bz2)       bunzip2 $1       ;;
		*.rar)       rar x $1     ;;
		*.gz)        gunzip $1     ;;
		*.tar)       tar xf $1        ;;
		*.tbz2)      tar xjf $1      ;;
		*.tgz)       tar xzf $1       ;;
		*.zip)       unzip $1     ;;
		*.Z)         uncompress $1  ;;
		*.7z)        7z x $1    ;;
		*)           echo "'$1' cannot be extracted via extract()" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

# automatic update
shellrc-reload() {
    if [[ -n $BASH_VERSION ]]; then
        source ~/.bashrc
    elif [[ -n $ZSH_VERSION ]]; then
        source ~/.zshrc
    fi
}

# ShellRc functions
shellrc-go() {
    cd "$SHELLRC_DIR"
}

shellrc-update() {
    git --git-dir="$SHELLRC_DIR/.git" --work-tree="$SHELLRC_DIR" pull --recurse-submodules
    shellrc-reload
}

shellrc-status() {
    git --git-dir="$SHELLRC_DIR/.git" --work-tree="$SHELLRC_DIR" status
}

shellrc-deploy() {
    git --git-dir="$SHELLRC_DIR/.git" --work-tree="$SHELLRC_DIR" add -A
    git --git-dir="$SHELLRC_DIR/.git" --work-tree="$SHELLRC_DIR" commit -m "update"
    git --git-dir="$SHELLRC_DIR/.git" --work-tree="$SHELLRC_DIR" push
}
# change directory with create when specified does not exist exist
cdc() {
    if [[ ! -d "$@" ]]; then
        mkdir "$@"
    fi
    cd "$@"
}

# clear contents of directory
cleardir() {
    local dir
    if [[ $# -eq 0 ]]; then
        dir=.
    elif [[ $# -eq 1 ]]; then
        dir="$1"
    else
        echo "cleardir: invalid number of arguments specified" 1>&2
        return 1
    fi
    
    if [[ ! -d "$dir" ]]; then
        echo "cleardir: - \"$dir\" is not a directory" 1>&2
        return 1
    fi

    local IFS=$'\n'
    find "$dir" -maxdepth 1 2>/dev/null | tail -n +2 | xargs rm -rf 2>/dev/null
}

# screen functions
source "$SHELLRC_DIR/screen/screen_profiles.sh"
