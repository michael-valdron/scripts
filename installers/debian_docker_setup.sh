#!/bin/sh

if [ ! -f '/etc/apt/sources.list.d/docker.list' ]
then
    if [ ! -z "$(command -v sudo)" ]
    then
        # Add Docker's official GPG key:
        sudo apt-get update -q
        sudo apt-get install -yq ca-certificates curl
        sudo install -m 0755 -d /etc/apt/keyrings
        sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc

        # Add the repository to Apt sources:
        echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

        # Update package lists
        sudo apt-get update -q
    else
        if [ $(whoami) != 'root' ]
        then
            echo "error: neither is root nor is sudo installed."
            exit 1
        else
            # Add Docker's official GPG key:
            apt-get update -q
            apt-get install -yq ca-certificates curl
            install -m 0755 -d /etc/apt/keyrings
            curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
            chmod a+r /etc/apt/keyrings/docker.asc

            # Add the repository to Apt sources:
            echo \
            "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
            $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
            tee /etc/apt/sources.list.d/docker.list > /dev/null

            # Update package lists
            apt-get update -q
        fi
    fi
else
    echo "docker repo is already setup"
fi
