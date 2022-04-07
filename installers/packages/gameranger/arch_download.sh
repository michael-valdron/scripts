#!/bin/sh

# Check if running as root
if [ "$EUID" -ne 0 ]
then
    echo "Please run as root"
    exit 1
fi

# Variables
DL_DIR=$(eval echo ~$SUDO_USER)/Downloads

# Install Dependencies
pacman -Sy --needed curl --noconfirm

# Download GameRanger
mkdir -p $DL_DIR
curl -o $DL_DIR/GameRangerSetup.exe -L http://www.gameranger.com/download/GameRangerSetup.exe

# Set User Permissions
chown $SUDO_USER:$SUDO_USER $DL_DIR/GameRangerSetup.exe

# Download Check
if [ ! -f $DL_DIR/GameRangerSetup.exe ]
then
    echo "GameRanger did not download correctly."
    exit 202
fi
