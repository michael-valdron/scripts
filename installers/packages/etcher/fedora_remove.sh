#!/bin/sh

# Install Etcher
sudo dnf -y remove balena-etcher

# Installation Check
if [ "$(command -v balena-etcher)" ]
then
    echo "Etcher was not removed correctly."
    exit 1
fi
