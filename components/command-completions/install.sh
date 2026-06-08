PREFIX="$(script_directory)/install"
rm -rf "$PREFIX"
(cd bash-completion && autoreconf -i && ./configure --prefix="$PREFIX" && make install)

