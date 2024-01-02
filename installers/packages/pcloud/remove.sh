#!/bin/sh

# Set pcloud install location
PCLOUD_INSTALL_PATH=${PCLOUD_INSTALL_PATH:-/opt/pcloud/pcloud}

# Kill pcloud process
echo "Killing any pcloud process.."
killall pcloud

# Remove pcloud
echo "Removing pcloud.."
sudo rm $PCLOUD_INSTALL_PATH
if [ $? -ne 0 ]
then
    echo "error: removal of pcloud failed"
    exit 1
fi

# Remove application launcher
echo "Removing application launcher.."
rm ${HOME}/.local/share/applications/appimagekit-pcloud.desktop

if [ $? -eq 0 ]; then echo "Done."; fi

