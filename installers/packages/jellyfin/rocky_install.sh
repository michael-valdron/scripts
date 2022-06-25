#!/bin/sh

# Check if running as root
if [ "$EUID" -ne 0 ]
then 
    echo "Please run as root"
    exit 1
fi

DISTRO=centos
VERSION=10.8.0-1

# Install RPM Fusion repositories
dnf -y install https://download1.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm \
    https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-8.noarch.rpm

# Install config-manager
dnf -y install 'dnf-command(config-manager)'

# Enable powertools
dnf -y config-manager --enable powertools

# Install Dependencies
dnf -y install SDL2 ffmpeg ffmpeg-devel which

# Install packages
dnf -y install --nobest https://repo.jellyfin.org/releases/server/${DISTRO}/stable/server/jellyfin-${VERSION}.el7.x86_64.rpm \
    https://repo.jellyfin.org/releases/server/${DISTRO}/stable/server/jellyfin-server-${VERSION}.el7.x86_64.rpm \
    https://repo.jellyfin.org/releases/server/${DISTRO}/stable/web/jellyfin-web-${VERSION}.el7.noarch.rpm

# Enable Jellyfin
systemctl enable jellyfin

# Installation Check
jellyfin_path=$(which jellyfin)
if [ -z "${jellyfin_path}" ]
then
    echo "Jellyfin was not installed correctly."
    exit 203
fi
