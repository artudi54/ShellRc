# git branch name
prompt-git-branch() {
	git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# git information for fancy prompt
prompt-git-status() {
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