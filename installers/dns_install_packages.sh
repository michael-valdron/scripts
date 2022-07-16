#!/bin/sh

# Check if running as root
if [ "$EUID" -ne 0 ]
then 
    echo "Please run as root"
    exit 1
fi

# Variables
base_dir=$(dirname $0)
pihole_install_script=/tmp/install-pihole.sh

# Run Rocky Linux setup script
sh $base_dir/debian_setup.sh

# Install Packages
apt-get install curl -yq

# Download PiHole Installer
curl -L https://install.pi-hole.net -o $pihole_install_script

# Do not run PiHole installer script if testing
if [ ! -z "${SCRIPT_TESTING}" ]
then
    # Check Install Script
    if [ -f $pihole_install_script ] 
    then
        echo "'${pihole_install_script}' exists.. ok!"
    else
        echo "'${pihole_install_script}' exists.. failed!"
        echo "PiHole installer script did not download correctly."
        exit 2
    fi
else
    # PiHole Install
    bash $pihole_install_script 
fi

exit 0
