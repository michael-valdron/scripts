#!/bin/sh

# Variables
ETCHER_GIT_REMOTE='https://github.com/balena-io/etcher.git'
ETCHER_VERSION=${ETCHER_VERSION:-''}

# Fetches latest version from etcher git source
fetch_latest() {
    local git_remote=$1
    local fetched_version=$(git -c 'versionsort.suffix=-' ls-remote --tags --sort='v:refname' ${git_remote} | tail --lines=1 | cut --delimiter='/' --fields=3)
    local fetched_version=${fetched_version%%'^{}'}
    echo ${fetched_version#'v'}
}

# Create required directories if they don't exist
sudo mkdir -p /tmp /opt/balena-etcher-electron/chrome-sandbox

# Install Dependencies
sudo dnf -y install git curl which util-linux shared-mime-info desktop-file-utils

# Use latest version if no version is set
if [ -z "${ETCHER_VERSION}" ]; then
    ETCHER_VERSION=$(fetch_latest ${ETCHER_GIT_REMOTE})
fi

# Download Etcher
curl -L "https://github.com/balena-io/etcher/releases/download/v${ETCHER_VERSION}/balena-etcher-${ETCHER_VERSION}-1.x86_64.rpm" -o /tmp/etcher.rpm

# Install Etcher
sudo rpm -i --quiet /tmp/etcher.rpm

# Installation Check
if [ ! "$(command -v balena-etcher)" ]
then
    echo "Etcher was not installed correctly."
    exit 1
fi
