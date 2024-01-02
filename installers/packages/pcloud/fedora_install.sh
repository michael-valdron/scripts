#!/bin/sh

PCLOUD_METADATA_DL_PATH=/tmp/pcloud-drive.tar.gz

if [ -z ${PCLOUD_DL_PATH} ]
then
    PCLOUD_DL_PATH=/tmp/pcloud
fi

if [ -z ${PCLOUD_INSTALL_PATH} ]
then
    PCLOUD_INSTALL_PATH=/opt/pcloud/pcloud
fi

# Download AUR metadata
echo "Downloading metadata.."
curl 'https://aur.archlinux.org/cgit/aur.git/snapshot/pcloud-drive.tar.gz' -o ${PCLOUD_METADATA_DL_PATH}

# Extract AUR metadata
echo "Extracting metadata.."
tar -xzf ${PCLOUD_METADATA_DL_PATH} -C /tmp

api_code=$(cat /tmp/pcloud-drive/PKGBUILD | grep '_api_code=' | sed -e "s/_api_code=//g" | sed -e "s/'//g")
api_response="$(curl -s "https://api.pcloud.com/getpublinkdownload?code=${api_code}")"
dlhost="$(echo ${api_response} | grep -E -o '[a-zA-Z0-9\-]+\.pcloud\.com' | head -n 2 | sort -R | head -n 1)"
dlpath="$(echo ${api_response} | grep -E -o "\"path\":\s{0,1}\".+\"" | cut -d '"' -f 4 | tr -d '\\')"
dlurl="https://${dlhost}${dlpath}"

# Download pcloud appimage
echo "Downloading pcloud appimage.."
curl ${dlurl} -o ${PCLOUD_DL_PATH}

# Install dependencies
echo "Installing dependencies.."
sudo dnf install fuse hicolor-icon-theme zlib libappindicator-gtk3 -y

# Install pcloud
echo "Installing pcloud.."
sudo mkdir -p $(dirname ${PCLOUD_INSTALL_PATH})
sudo install -o root -g root -m 0755 ${PCLOUD_DL_PATH} ${PCLOUD_INSTALL_PATH}

if [ $? -eq 0 ]; then echo "Done."; fi

