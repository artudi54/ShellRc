autoload -Uz array-append-unique
array-append-unique path "$(script_directory)/bin"

for file in "$(script_directory)"/functions/*.sh; do
    include "$file"
done
unset file

for file in "$(script_directory)"/functions/completion/*.sh; do
    include "$file"
done
unset file

for file in "$(script_directory)"/scripts/completion/*.sh; do
    include "$file"
done
unset file

