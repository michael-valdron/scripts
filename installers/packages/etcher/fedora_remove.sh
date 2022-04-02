#!/bin/sh

# Check if running as root
if [ "$EUID" -ne 0 ]
then 
    echo "Please run as root"
    exit 1
fi

# Install Etcher
rm /usr/bin/etcher
dnf -y remove balena-etcher-electron

# Installation Check
ETCHER_PATH=$(which etcher)
if [ ! -z "${ETCHER_PATH}" ]
then
    echo "Etcher was not removed correctly."
    exit 305
fi
