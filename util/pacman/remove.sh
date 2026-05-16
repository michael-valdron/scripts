#!/bin/sh

if [ "$(command -v pacman)" ]
then
    sudo pacman -Rs $@
else
    echo "system does not use pacman"
    exit 1
fi
