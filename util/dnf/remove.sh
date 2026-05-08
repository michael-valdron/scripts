#!/bin/sh

if [ "$(command -v dnf)" ]
then 
    sudo dnf remove $@
else 
    echo "system does not use dnf" 
    exit 1
fi
