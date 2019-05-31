# plugin for showing command information in shell


# ubuntu default command-not-found
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; then
    command_not_found_handle() {
        if [ -x /usr/lib/command-not-found ]; then
            /usr/lib/command-not-found -- "$1"
            return $?
        elif [ -x /usr/share/command-not-found/command-not-found ]; then
            /usr/share/command-not-found/command-not-found -- "$1"
            return $?
        else
           printf "%s: command not found\n" "$1" >&2
           return 127
        fi
    }
    command_not_found_handler() {
        command_not_found_handle "$@"
    }
fi

#TODO
return 
#arch zsh
command_not_found_handler() {
  local pkgs cmd="$1"

  pkgs=(${(f)"$(pkgfile -b -v -- "$cmd" 2>/dev/null)"})
  if [[ -n "$pkgs" ]]; then
    printf '%s may be found in the following packages:\n' "$cmd"
    printf '  %s\n' $pkgs[@]
    return 0
  fi

  printf 'zsh: command not found: %s\n' "$cmd" 1>&2
  return 127
}

#arch bash
command_not_found_handle () {
  local pkgs cmd=$1
  local FUNCNEST=10

  set +o verbose

  mapfile -t pkgs < <(pkgfile -bv -- "$cmd" 2>/dev/null)

  if [[ ${#pkgs[*]} -eq 1 && -n $PKGFILE_PROMPT_INSTALL_MISSING ]]; then
    local pkg=${pkgs[0]%% *}
    local response

    read -r -p "Install $pkg? [Y/n] " response
    [[ -z $response || $response = [Yy] ]] || return 0
    printf '\n'
    sudo pacman -S --noconfirm -- "$pkg"
    return 0
  fi

  if (( ${#pkgs[*]} )); then
    printf '%s may be found in the following packages:\n' "$cmd"
    printf '  %s\n' "${pkgs[@]}"
    return 0
  else
    printf "bash: %s: command not found\n" "$cmd" >&2
    return 127
  fi
}

#arch fish
function command_not_found_handler --on-event fish_command_not_found
    set cmd $argv

    if set pkgs (pkgfile -bv -- "$cmd" 2>/dev/null)
        printf '%s may be found in the following packages:\n' "$cmd"
        for pkg in $pkgs
            printf '  %s\n' "$pkg"
        end
    end
end

#arch zsh
command_not_found_handler() {
  local pkgs cmd="$1"

  pkgs=(${(f)"$(pkgfile -b -v -- "$cmd" 2>/dev/null)"})
  if [[ -n "$pkgs" ]]; then
    printf '%s may be found in the following packages:\n' "$cmd"
    printf '  %s\n' $pkgs[@]
  else
    printf "bash: %s: command not found\n" "$cmd" >&2
    return 127
  fi
}
