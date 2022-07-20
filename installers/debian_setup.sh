#!/bin/sh

# Check if running as root
if [ "$EUID" -ne 0 ]
then 
    echo "Please run as root"
    exit 1
fi

# Update package lists and upgrade installed packages
apt-get update -q && apt-get upgrade -yq
