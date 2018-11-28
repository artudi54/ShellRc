# Set up the prompt
autoload -Uz promptinit
promptinit
setopt PROMPT_SUBST

unset PS1
unset PROMPT
unset PROMPT_COMMAND

__SEPARATOR=$'\ue0b0'
__USER_COLOR=35
__DIR_COLOR=32
__GIT_COLOR=33
__PROMPT_USER="%B%K{$__USER_COLOR}%n@%m%K{$__DIR_COLOR}%F{$__USER_COLOR}$__SEPARATOR %F{none}%b"
__PROMPT_DIR="%B%c%K{$__GIT_COLOR}%F{$__DIR_COLOR}$__SEPARATOR%F{none}%b"
__prompt_git_impl() {
  BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/*\(.*\)/\1/')

  if [ ! -z $BRANCH ]; then
    echo -n "%F{yellow}$BRANCH"

    if [ ! -z "$(git status --short)" ]; then
      echo " %F{red}✗"
    fi
  fi
}
__prompt_git() {
	info=$(__prompt_git_impl)
	if [[ $ref != "" ]]; then
		echo "${ref}%K{none}%F{$__GIT_COLOR}$__SEPARATOR%F{none}"
	else
		echo "%K{none}"
	fi
}

#export PROMPT='$__PROMPT_USER$__PROMPT_DIR$(__prompt_git)'
export PS1=$'${debian_chroot:+($debian_chroot)} $(return-face) \033[01;33m[%*]\033[00m \033[01;32m%n@%M\033[00m:\033[01;34m%1~\033[00m\033[01;31m$(git-prompt-branch)\033[00m\$ '
