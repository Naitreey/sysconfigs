#!/bin/bash
if [ "$ACTION" == "add" ]; then
    sudo -u naitree gsettings set org.gnome.desktop.input-sources xkb-options \
        "['caps:ctrl_modifier', 'altwin:swap_alt_win']"
fi
