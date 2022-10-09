#!/bin/sh

# Check if running as root
if [ "$EUID" -ne 0 ]
then
    echo "Please run as root"
    exit 1
fi

# Enable Multilib
echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

# Update packages
pacman -Syu --noconfirm

# Install packages
pacman -Sy --needed base-devel git steam discord wine vkd3d lib32-vkd3d lutris sauerbraten sauerbraten-data dosbox --noconfirm

# # Install Dolphin
# sh packages/dolphin/arch_install.sh
# STATUS=$?
# if [ $STATUS -ne 0 ]
# then
#     echo "Dolphin failed to install."
#     exit $STATUS
# fi

# Download GameRanger
sh packages/gameranger/arch_download.sh
STATUS=$?
if [ $STATUS -ne 0 ]
then
    echo "GameRanger failed to download."
    exit $STATUS
fi

# Download Well Of Souls
sh packages/wos/arch_download.sh
STATUS=$?
if [ $STATUS -ne 0 ]
then
    echo "Well Of Souls failed to download."
    exit $STATUS
fi
