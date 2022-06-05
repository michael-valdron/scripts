#!/bin/sh

# Check if running as root
if [ "$EUID" -ne 0 ]
then 
    echo "Please run as root"
    exit 1
fi

# Update packages
dnf -y update --refresh

# Install EPEL repository
dnf -y install epel-release
