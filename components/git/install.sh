dir="$(script-directory)"
mkdir -p "$XDG_CONFIG_HOME/git"
printf "[include]\tpath = \"$dir/gitconfig.ini\"\n" >"$XDG_CONFIG_HOME/git/config" 
IFS=$'\n' read -p "Enter your name: " name
read -p "Enter your email: " email
git config --global include.path "$dir/gitconfig.ini"
git config --global user.name "$name"
git config --global user.email "$email"

