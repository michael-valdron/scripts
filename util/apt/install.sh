#!/bin/sh

if [ "$(command -v apt)" ]
then
    sudo apt update  # Important: Refresh package lists first!
    sudo apt install $@
else
    echo "system does not use apt"
    exit 1
fi
