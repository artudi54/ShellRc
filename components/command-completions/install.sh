PREFIX="$(script_directory)/install"
rm -rf "$PREFIX"
(cd "$(script_directory)/bash-completion" && autoreconf -i && ./configure --prefix="$PREFIX" && make install)

