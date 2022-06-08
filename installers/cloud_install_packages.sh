#!/bin/sh

# Check if running as root
if [ "$EUID" -ne 0 ]
then 
    echo "Please run as root"
    exit 1
fi

# Variables
base_dir=$(dirname $0)

# Run Rocky Linux setup script
sh $base_dir/rocky_setup.sh

# Install packages
dnf -y install podman podman-compose podman-docker git

# Test podman
podman --version

exit 0
