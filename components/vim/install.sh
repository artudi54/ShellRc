dir="$(script_directory)"

#ycm
python3 "$dir/plugins/YouCompleteMe/install.py" --all

# color_coded
rm -f "$dir/plugins/color_coded/CMakeCache.txt"
rm -rf "$dir/plugins/color_coded/build"
mkdir "$dir/plugins/color_coded/build"
(cd "$dir/plugins/color_coded/build" && cmake .. && make install && make clean && make clean_clang)

