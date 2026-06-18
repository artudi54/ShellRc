# Register autoloadable function directories
# functions/ — both shells; zsh/zsh-stubs — bash only (reimplementations)
[[ " ${fpath[*]} " != *" $(script_directory)/functions "* ]] && fpath+=("$(script_directory)/functions")
for p in "$(script_directory)"/functions/zsh "$(script_directory)"/functions/zsh-stubs; do
    if [[ -v BASH_VERSION ]] && [[ -d "$p" ]]; then
        [[ " ${fpath[*]} " != *" $p "* ]] && fpath+=("$p")
    fi
done
unset p
if [[ -v BASH_VERSION ]]; then
    __bound-vars-sync
fi

for file in "$(script_directory)"/completions/*.sh; do
    include "$file"
done
unset file

