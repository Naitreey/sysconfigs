#!/bin/bash -e
if [[ $1 == dump ]]; then
    exec dconf dump /com/gexperts/Tilix/
elif [[ $1 == restore ]]; then
    exec dconf load /com/gexperts/Tilix/
else
    echo "usage: $0 {dump|restore}"
fi
