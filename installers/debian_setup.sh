#!/bin/sh

# Update package lists and upgrade installed packages
if [ ! -z "$(command -v sudo)" ]
then
    sudo apt-get update -q && apt-get upgrade -yq
else
    if [ $(whoami) != 'root' ]
    then
        echo "error: neither is root nor is sudo installed."
        exit 1
    else
        apt-get update -q && apt-get upgrade -yq
    fi
fi
