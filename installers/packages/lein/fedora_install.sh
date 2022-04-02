#!/bin/sh

# Check if running as root
if [ "$EUID" -ne 0 ]
then 
    echo "Please run as root"
    exit 1
fi

# Install Dependencies
dnf -y install curl which java-11-openjdk clojure

# Download & Install Leiningen
curl -L "https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein" -o /usr/local/bin/lein
chmod +x /usr/local/bin/lein
ln -s /usr/local/bin/lein /usr/bin/lein

# Installation Check
LEIN_PATH=$(which lein)
if [ -z "${LEIN_PATH}" ]
then
    echo "Leiningen was not installed correctly."
    exit 208
fi

# Run Self Install
lein
