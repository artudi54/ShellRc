#!/usr/bin/env bash

while read -r interface; do
    if [[ "$(/usr/lib/qt6/bin/qdbus "$interface" /dolphin/Dolphin_1 org.kde.dolphin.MainWindow.isActiveWindow)" == "true" ]]; then
        /usr/lib/qt6/bin/qdbus "$interface" /dolphin/Dolphin_1  org.kde.dolphin.MainWindow.openDirectories "admin://$1" false
    fi
done < <(/usr/lib/qt6/bin/qdbus | grep org.kde.dolphin)

