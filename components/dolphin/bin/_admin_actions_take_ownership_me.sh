#!/usr/bin/env bash
set -e

pkexec chown $USER:"$(id -g)" "$@"

while read -r interface; do
    if [[ "$(/usr/lib/qt6/bin/qdbus "$interface" /dolphin/Dolphin_1 org.kde.dolphin.MainWindow.isActiveWindow)" == "true" ]]; then
        /usr/lib/qt6/bin/qdbus "$interface" /dolphin/Dolphin_1/actions/view_redisplay org.qtproject.Qt.QAction.trigger
    fi
done < <(/usr/lib/qt6/bin/qdbus | grep org.kde.dolphin)
