#!/bin/sh

# Check if running as root
if [ "$EUID" -ne 0 ]
then 
    echo "Please run as root"
    exit 1
fi

# Variables
VERSION="6.0.8"

# Create required directories if they don't exist
mkdir -p /tmp

# Install Dependencies
dnf -y install curl which bzip2

# Download Zotero
curl -L "https://www.zotero.org/download/client/dl?channel=release&platform=linux-x86_64&version=${VERSION}" -o /tmp/zotero.tar.bz2

# Install Zotero
tar -xf /tmp/zotero.tar.bz2 -C /tmp
if [ -d /opt/zotero ]; then rm -rf /opt/zotero; fi
mv /tmp/Zotero_linux-x86_64 /opt/zotero
cp $(dirname $0)/run.sh /opt/zotero/run.sh
chmod +x /opt/zotero/run.sh
if [ ! -f /usr/bin/zotero ]; then ln -s /opt/zotero/run.sh /usr/bin/zotero; fi
if [ ! -f /usr/local/share/applications/zotero.desktop ]
then
    ln -s /opt/zotero/zotero.desktop /usr/local/share/applications/zotero.desktop
fi

# Installation Check
ZOTERO_PATH=$(which zotero)
if [ -z "${ZOTERO_PATH}" ]
then
    echo "Zotero was not installed correctly."
    exit 206
fi
