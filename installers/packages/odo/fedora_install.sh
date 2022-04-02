#!/bin/sh

# Check if running as root
if [ "$EUID" -ne 0 ]
then 
    echo "Please run as root"
    exit 1
fi

# Variables
if [ -z "$VERSION" ]
then
    VERSION="latest"
fi

# Install Dependencies
dnf -y install curl which

# Download & Install odo
curl -L "https://mirror.openshift.com/pub/openshift-v4/clients/odo/${VERSION}/odo-linux-amd64" -o /usr/local/bin/odo
chmod +x /usr/local/bin/odo

# Installation Check
ODO_PATH=$(which odo)
if [ -z "${ODO_PATH}" ]
then
    echo "odo was not installed correctly."
    exit 202
fi

# Run Command
odo -h
