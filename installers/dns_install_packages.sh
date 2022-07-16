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
dnf -y install htop neofetch tmux git

# PiHole Install
curl -sSL https://install.pi-hole.net | bash

# Test neofetch
neofetch

# Test htop
htop --version

# Test tmux
tmux -V

exit 0

