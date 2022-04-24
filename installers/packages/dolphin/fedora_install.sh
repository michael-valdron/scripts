#!/bin/sh

# Check if running as root
if [ "$EUID" -ne 0 ]
then 
    echo "Please run as root"
    exit 1
fi

# Variables
DL_DIR=/tmp/dolphin
VERSION="5.0"

# Install Dependencies
dnf -y install gcc gcc-c++ cmake make git

# Download Dolphin Source
git clone https://github.com/dolphin-emu/dolphin.git $DL_DIR

cd $DL_DIR

# Select Source Version
git checkout tags/$VERSION

# Build Source
mkdir -p $DL_DIR/Build
cd $DL_DIR/Build
cmake .. && make

# Install Dolphin
make install

# Remove Source
rm -rf $DL_DIR

# Installation Check
DOLPHIN_PATH=$(which dolphin-emu)
if [ -z "${DOLPHIN_PATH}" ]
then
    echo "Dolphin was not installed correctly."
    exit 203
fi
