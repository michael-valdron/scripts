#!/bin/sh

# Check if running as root
if [ "$EUID" -ne 0 ]
then 
    echo "Please run as root"
    exit 1
fi

# Enable fusion repositorties
dnf -y install "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
dnf -y install "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

# Update packages
dnf -y update

if [ -z "${1}" ] || [ "${1}" != "1" ]
then
    # Add flatpak remotes
    flatpak remote-add --if-not-exists flathub "https://flathub.org/repo/flathub.flatpakrepo"
fi
