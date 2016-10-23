#!/bin/bash
if [ "$ACTION" == "add" ]; then
    /home/naitree/bin/k810_conf -d "$DEVNAME" -f on
    sudo -u naitree gsettings set org.gnome.desktop.input-sources xkb-options \
        "['caps:ctrl_modifier']"
fi
