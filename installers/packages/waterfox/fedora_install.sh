#!/bin/sh

# Check if running as root
if [ "$EUID" -ne 0 ]
then 
    echo "Please run as root"
    exit 1
fi

# Variables
WATERFOX_VERSION="G4.0.7"

# Create required directories if they don't exist
mkdir -p /tmp /opt

# Install Dependencies
dnf -y install curl bzip2 which

# Download Waterfox
curl -L "https://github.com/WaterfoxCo/Waterfox/releases/download/${WATERFOX_VERSION}/waterfox-${WATERFOX_VERSION}.en-US.linux-x86_64.tar.bz2" -o /tmp/waterfox.tar.bz2

# Install Waterfox
tar -xf /tmp/waterfox.tar.bz2 -C /tmp
mv /tmp/waterfox /opt/waterfox
chmod +x /opt/waterfox/waterfox
ln -s /opt/waterfox/waterfox /usr/bin/waterfox
cp waterfox.desktop /opt/waterfox/waterfox.desktop
ln -s /opt/waterfox/waterfox.desktop /usr/local/share/applications/waterfox.desktop

# Installation Check
WATERFOX_PATH=$(which waterfox)
if [ -z "${WATERFOX_PATH}" ]
then
    echo "Waterfox was not installed correctly."
    exit 203
fi