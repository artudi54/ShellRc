for file in "$(script_directory)"/functions/*.sh; do
    include "$file"
done
unset file

for file in "$(script_directory)"/functions/completion/*.sh; do
    include "$file"
done
unset file

for file in "$(script_directory)"/environment/*.sh; do
    include "$file"
done
unset file
