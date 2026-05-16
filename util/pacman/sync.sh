#!/bin/sh

if [ "$(command -v pacman)" ]
then
    sudo pacman -Sy $@
else
    echo "system does not use pacman"
    exit 1
fi
