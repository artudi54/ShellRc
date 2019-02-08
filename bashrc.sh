# If not running interactively, don"t do anything
case $- in
    *i*) ;;
      *) return;;
esac

current_dir=$(dirname "$BASH_SOURCE")
source "$current_dir/shell/shellrc.sh"

# environmental variables
if [ -f "$current_dir/common_env.sh" ]; then
	source "$current_dir/common_env.sh"
fi

# fancy prompt
if [ -f "$current_dir/shell/prompt/prompt.sh" ]; then
	source "$current_dir/shell/prompt/prompt.sh"
fi

# output colouring
if [ -f "$current_dir/common_colours.sh" ]; then
	source "$current_dir/common_colours.sh"
fi

# aliases
if [ -f "$current_dir/common_aliases.sh" ]; then
    source "$current_dir/common_aliases.sh"
fi

# functions
if [ -f "$current_dir/common_fun.sh" ]; then
    source "$current_dir/common_fun.sh"
fi

# autocompletion
if [ -f "$current_dir/bashrc_completion.sh" ]; then
    source "$current_dir/bashrc_completion.sh"
fi


unset current_dir
