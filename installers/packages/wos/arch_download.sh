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

# Download Well Of Souls
mkdir -p $DL_DIR
curl -o $DL_DIR/WellOfSouls.exe -L http://www.synthetic-reality.us/WellOfSouls.exe

# Set User Permissions
chown $SUDO_USER:$SUDO_USER $DL_DIR/WellOfSouls.exe

# Download Check
if [ ! -f $DL_DIR/WellOfSouls.exe ]
then
    echo "Well Of Souls did not download correctly."
    exit 202
fi
