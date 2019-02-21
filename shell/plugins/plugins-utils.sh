 # Functions for manipulating plugins

# current enabled plugins
shellrc-plugins() {
    echo "$PLUGINS[@]"
}

# listing available plugins
shellrc-plugins-list() {
    ls $SHELLRC_DIR/shell/plugins/entries/*.plugin.sh 2>/dev/null | awk -F'/' '{print $NF }' | sed 's/.plugin.sh//'
}

# enable plugin
shellrc-plugins-enable() {
    echo TODO
    return 1
}

# disable plugin
shellrc-plugins-disable() {
    echo TODO
    return 1
}
