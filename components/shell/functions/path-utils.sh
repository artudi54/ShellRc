# path show
pathshow() {
	echo -e ${PATH//:/\\n}
}

# quick add to path
pathadd() {
	if [ $# -ne 0 ]; then
		export PATH="$PATH:$@"
	else
		echo "No path specified"
	fi
}