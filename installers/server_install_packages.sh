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
dnf -y install htop neofetch tmux zsh podman podman-compose podman-docker samba git

# Install ZFS
sh $base_dir/packages/zfs/rocky_install.sh
status=$?
if [ $status -ne 0 ]
then
    echo "ZFS failed to install."
    exit $status
fi

# Test neofetch
neofetch

# Test htop
htop --version

# Test tmux
tmux -V

# Test zsh
zsh --version

# Test podman
podman --version

exit 0
