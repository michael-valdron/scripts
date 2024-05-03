#!/bin/sh

if [ "$(command -v dnf)" ]
then 
    sudo dnf install $@
else 
    echo "system does not use dnf" 
    exit 1
fi
