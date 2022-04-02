#!/bin/sh

# Check if running as root
if [ "$EUID" -ne 0 ]
then 
    echo "Please run as root"
    exit 1
fi

# Create required directories if they don't exist
mkdir -p /tmp

# Install Dependencies
dnf -y install curl which libappindicator libXScrnSaver libsecret redhat-lsb-core

# Download Mailspring
curl -L "https://updates.getmailspring.com/download?platform=linuxRpm" -o /tmp/mailspring.rpm

# Install Mailspring
rpm -i --quiet /tmp/mailspring.rpm

# Installation Check
MAILSPRING_PATH=$(which mailspring)
if [ -z "${MAILSPRING_PATH}" ]
then
    echo "Mailspring was not installed correctly."
    exit 204
fi
