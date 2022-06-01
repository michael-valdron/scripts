#!/bin/sh

# Check if running as root
if [ "$EUID" -ne 0 ]
then 
    echo "Please run as root"
    exit 1
fi

# Variables
VERSION="1.7.9"

# Create required directories if they don't exist
mkdir -p /tmp /opt/balena-etcher-electron/chrome-sandbox

# Install Dependencies
dnf -y install curl which util-linux shared-mime-info desktop-file-utils

# Download Etcher
curl -L "https://github.com/balena-io/etcher/releases/download/v${VERSION}/balena-etcher-electron-${VERSION}.x86_64.rpm" -o /tmp/etcher.rpm

# Install Etcher
rpm -i --quiet /tmp/etcher.rpm
if [ ! -f /usr/bin/etcher ]; then ln -s /opt/balenaEtcher/balena-etcher-electron /usr/bin/etcher; fi

# Installation Check
ETCHER_PATH=$(which etcher)
if [ -z "${ETCHER_PATH}" ]
then
    echo "Etcher was not installed correctly."
    exit 205
fi
