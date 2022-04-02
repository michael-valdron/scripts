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

# Create required directories if they don't exist
mkdir -p /tmp

# Install Dependencies
dnf -y install curl which

# Download Minikube
curl -L "https://storage.googleapis.com/minikube/releases/${VERSION}/minikube-${VERSION}.x86_64.rpm" -o /tmp/minikube.x86_64.rpm

# Install Minikube
rpm -Uvh /tmp/minikube.x86_64.rpm

# Installation Check
MINIKUBE_PATH=$(which minikube)
if [ -z "${MINIKUBE_PATH}" ]
then
    echo "Minikube was not installed correctly."
    exit 201
fi

# Run Command
minikube version
