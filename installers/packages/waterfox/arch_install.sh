#!/bin/sh

# Check if running as root
if [ "$EUID" -ne 0 ]
then 
    echo "Please run as root"
    exit 1
fi

# Variables
WATERFOX_VERSION="G4.1.3"
BASE_PATH=$(dirname $0)

# If in directory script is located.
if [ -z "$BASE_PATH" ]
then
    BASE_PATH="."
fi

# Create required directories if they don't exist
mkdir -p /tmp /opt

# Install Dependencies
pacman -Sy --needed curl bzip2 which --noconfirm

# Download Waterfox
curl -L "https://github.com/WaterfoxCo/Waterfox/releases/download/${WATERFOX_VERSION}/waterfox-${WATERFOX_VERSION}.en-US.linux-x86_64.tar.bz2" -o /tmp/waterfox.tar.bz2

# Install Waterfox
tar -xf /tmp/waterfox.tar.bz2 -C /tmp
if [ -d /opt/waterfox ]; then rm -rf /opt/waterfox; fi
mv /tmp/waterfox /opt/waterfox
chmod +x /opt/waterfox/waterfox
if [ ! -f /usr/bin/waterfox ]; then ln -s /opt/waterfox/waterfox /usr/bin/waterfox; fi
cp $BASE_PATH/waterfox.desktop /opt/waterfox/waterfox.desktop
if [ ! -f /usr/local/share/applications/waterfox.desktop ]
then
    mkdir -p /usr/local/share/applications
    ln -s /opt/waterfox/waterfox.desktop /usr/local/share/applications/waterfox.desktop
fi

# Installation Check
WATERFOX_PATH=$(which waterfox)
if [ -z "${WATERFOX_PATH}" ]
then
    echo "Waterfox was not installed correctly."
    exit 203
fi
