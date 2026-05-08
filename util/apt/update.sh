#!/bin/sh

if [ "$(command -v apt)" ]
then
    sudo apt update # Refresh package lists before updating
    sudo apt upgrade $@
else
    echo "system does not use apt"
    exit 1
fi
