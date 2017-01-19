#!/bin/bash
declare TRUE=0
declare FALSE=1

declare file="$1"
declare dest="$2"
nc -u devServer 10001 < /home/naitree/Desktop/secrecy/ng8w-project/knock
sleep 0.1
scp -p -P 22999 -r "$file" root@devServer:/home/naitree/temp
declare filename="$(basename "$file")"
ssh -p 22999 -tt root@devServer << EOF
cp -p -r /home/naitree/temp/"$filename" "$dest"
logout
EOF
