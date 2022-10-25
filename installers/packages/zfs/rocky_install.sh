#!/bin/sh

# Check if running as root
if [ "$EUID" -ne 0 ]
then 
    echo "Please run as root"
    exit 1
fi

# Install ZFS repository
dnf -y install https://zfsonlinux.org/epel/zfs-release-2-2$(rpm --eval "%{dist}").noarch.rpm

# Import GPG Key
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-zfsonlinux

# Install packages
dnf -y install kernel-devel zfs

# Create ZFS module load config
sh -c "echo zfs > /etc/modules-load.d/zfs.conf"

# Installation Check
zpool_path=$(which zpool)
if [ -z "${zpool_path}" ]
then
    echo "ZFS was not installed correctly."
    exit 203
fi
