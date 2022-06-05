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
dnf -y install htop neofetch tmux zsh podman @virt virt-top libguestfs-tools virt-install nginx php php-pgsql postgresql-server \
    samba

# Install ZFS
sh $base_dir/packages/zfs/rocky_install.sh
status=$?
if [ $status -ne 0 ]
then
    echo "ZFS failed to install."
    exit $status
fi

# Install Jellyfin
sh $base_dir/packages/jellyfin/rocky_install.sh
status=$?
if [ $status -ne 0 ]
then
    echo "Jellyfin failed to install."
    exit $status
fi

# Enable libvirtd
systemctl enable libvirtd

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

# Test qemu
qemu-img --version

# Test pg
psql --version

# Test Jellyfin
jellyfin --version

exit 0
