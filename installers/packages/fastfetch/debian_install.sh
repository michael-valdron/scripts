#!/bin/sh

# Variables
VERSION=${VERSION:-'latest'}

# Install dependencies
if [ ! -z "$(command -v sudo)" ]
then
    sudo apt-get update -q && sudo apt-get install -yq curl
else
    if [ "$(whoami)" != "root" ]
    then
        echo "error: neither is root nor is sudo installed."
        exit 1
    else
        apt-get update -q && apt-get install -yq curl
    fi
fi

# Download FastFetch
if [ "${VERSION}" != "latest" ]; then
    curl -L "https://github.com/fastfetch-cli/fastfetch/releases/download/${VERSION}/fastfetch-linux-amd64.deb" -o /tmp/fastfetch-linux-amd64.deb
else
    curl -L "https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-amd64.deb" -o /tmp/fastfetch-linux-amd64.deb
fi

# Install FastFetch
install_cmd='dpkg -i /tmp/fastfetch-linux-amd64.deb'
if [ ! -z "$(command -v sudo)" ]
then
    sudo ${install_cmd}
else
    if [ "$(whoami)" != "root" ]
    then
        echo "error: neither is root nor is sudo installed."
        exit 1
    else
        ${install_cmd}
    fi
fi

# Installation Check
FASTFETCH_PATH=$(which fastfetch)
if [ -z "${FASTFETCH_PATH}" ]
then
    echo "FastFetch was not installed correctly."
    exit 205
fi
