#!/bin/sh

# Check if running as root
if [ "$EUID" -ne 0 ]
then 
    echo "Please run as root"
    exit 1
fi

# Variables
install_dir="/opt/waterfox"
bin_link="/usr/bin/waterfox"
app_file="/usr/local/share/applications/waterfox.desktop"

# Remove application directory
if [ -d $install_dir ]
then
    echo "Removing Waterfox.."
    rm -rf $install_dir
    echo "Waterfox removed!"
else
    echo "Waterfox is not installed."
fi

# Remove binary symbolic link under /usr/bin
if [ -L $bin_link ]
then
    echo "Removing bin symbolic link.."
    rm $bin_link
    echo "Waterfox bin symbolic link removed!"
fi

# Remove application link from applications directory (Application Menu Shortcut)
if [ -L $app_file ]
then
    echo "Removing application link.."
    rm $app_file
    echo "Waterfox application link removed!"
fi
