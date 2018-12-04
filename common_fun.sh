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

# fancy return code face
return-face() {
	if [ $? -eq 0 ]; then
		printf '\001\033[1;34m\002(^_^)\001\033[0m\002'
	else
		printf '\001\033[1;31m\002(O_O)\001\033[0m\002'
	fi
}

# git information for fancy prompt
git-prompt-status() {
	MODIFIED="${C_LIGHTYELLOW}✎${C_NC}"
	MODIFIEDADDED="${C_GREEN}✎${C_NC}"
	DELETED="${C_RED}-${C_NC}"
	UNTRACKED="${C_LIGHTGRAY}?${C_NC}"
	status=$(git status -s 2>/dev/null | awk '{ print $1 }')
	printf "%s\nl${status}l"
	modified=false
	untracked=false
	deleted=false
	output=""
	if [[ $? == 0 ]]; then
		for entry in $status; do
			if [[ $entry == "M" ]]; then
				modified=true
			elif [[ $entry == "D" ]]; then
				deleted=true
			elif [[ $entry == "??" ]]; then
				untracked=true
			else
				echo "Unknown"
			fi
		done
		if [[ $modified ]]; then
			output=$output$MODIFIED
		fi
		if [[ $deleted ]]; then
			output=$output$DELETED
		fi
		if [[ $untracked ]]; then
			output=$output$UNTRACKED
		fi
		echo -e $output
	fi
}

git-prompt-branch() {
	git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# automatic update
shellrc-reload() {
    if [[ -n $BASH_VERSION ]]; then
        source ~/.bashrc
    elif [[ -n $ZSH_VERSION ]]; then
        source ~/.zshrc
    fi
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

# screen functions
source "$SHELLRC_DIR/screen/screen_profiles.sh"
