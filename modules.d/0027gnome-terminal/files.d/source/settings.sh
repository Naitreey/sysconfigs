#!/bin/bash

# get default profile uuid
# default='xxxx-xxxx....'
eval $(dconf dump /org/gnome/terminal/legacy/profiles:/ | grep -e '^default=')
if [[ $1 == dump ]]; then
    dconf dump /org/gnome/terminal/legacy/profiles:/:$default/ >gnome-terminal.conf
elif [[ $1 == load ]]; then
    dconf load /org/gnome/terminal/legacy/profiles:/:$default/ <gnome-terminal.conf
else
    echo "usage: $0 (dump|load)"
fi
