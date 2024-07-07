#!/bin/sh

# Variables
base_dir=$(dirname $0)

# Run Debian Linux setup script
sh $base_dir/debian_setup.sh

STATUS=$?
if [ $STATUS -ne 0 ]
then
    echo "Setup failed."
    exit $STATUS
fi

# Run Debian Docker setup script
sh $base_dir/debian_docker_setup.sh

STATUS=$?
if [ $STATUS -ne 0 ]
then
    echo "Docker setup failed."
    exit $STATUS
fi

# Install apt packages
install_cmd='apt-get install -yq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin bind9 bind9-doc nano htop tmux git curl'
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

# Install FastFetch
sh ${base_dir}/packages/fastfetch/debian_install.sh
STATUS=$?
if [ $STATUS -ne 0 ]
then
    echo "FastFetch failed to install."
    exit $STATUS
fi
