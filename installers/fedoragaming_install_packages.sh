#!/bin/sh

# Check if running as root
if [ "$EUID" -ne 0 ]
then 
    echo "Please run as root"
    exit 1
fi

YUM_REPOS_DIR=/etc/yum.repos.d
BASE_DIR=$(dirname $0)

# Run base setup
sh $BASE_DIR/fedora_setup.sh 1

# Add yadm repository, if not exist
if [ ! -f $YUM_REPOS_DIR/home:TheLocehiliosan:yadm.repo ] && [ ! -f $YUM_REPOS_DIR/yadm.repo ];
then
    cp $BASE_DIR/repos/fedora/yadm.repo $YUM_REPOS_DIR/yadm.repo
fi

# Remove packages
dnf -y remove firefox kmail konversation krdc krfb libreoffice-core kontact kde-connect akregator \
    kaddressbook korganizer qt5-qdbusviewer qt-qdbusviewer qt6-qdbusviewer

# Update packages
dnf -y update

# Install packages
dnf -y install neofetch cmatrix tmux htop gcc gcc-c++ curl make cmake flatpak steam \
    unzip wget openssl yadm wine wine-dxvk winetricks wine-dxvk-d3d9 wine-dxvk-dxgi \
    lutris dolphin-emu

# Add flatpak remotes
flatpak remote-add --if-not-exists flathub "https://flathub.org/repo/flathub.flatpakrepo"

# Install flatpaks
## Firefox Install
flatpak install -y flathub org.mozilla.firefox
## DOSBox Install
flatpak install -y flathub com.dosbox.DOSBox
## Discord Install
flatpak install -y flathub com.discordapp.Discord
## DejaDup Install
flatpak install -y flathub org.gnome.DejaDup
## VLC Install
flatpak install -y flathub org.videolan.VLC
