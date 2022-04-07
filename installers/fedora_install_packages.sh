#!/bin/sh

# Check if running as root
if [ "$EUID" -ne 0 ]
then 
    echo "Please run as root"
    exit 1
fi

# Enable fusion repositorties
dnf -y install "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
dnf -y install "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

# Add Visual Studio Code repository
rpm --import "https://packages.microsoft.com/keys/microsoft.asc"
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

# Add GCP SDK repository
sudo tee -a /etc/yum.repos.d/google-cloud-sdk.repo << EOM
[google-cloud-sdk]
name=Google Cloud SDK
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el8-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOM

# Update packages
dnf -y update

# Install packages
dnf -y install neofetch cmatrix tmux htop ufw zsh gcc gcc-c++ curl make cmake go java-11-openjdk clojure code chromium podman podman-docker podman-compose \
    firefox flatpak keepassxc gimp libreoffice calibre xournalpp clamav clamtk vlc sqlitebrowser p7zip p7zip-gui p7zip-plugins cheese @virtualization \
    unzip wget libappindicator redhat-lsb-core google-cloud-sdk bridge-utils openssl

# Install Minikube
sh packages/minikube/fedora_install.sh
STATUS=$?
if [ $STATUS -ne 0 ]
then
    echo "Minikube failed to install."
    exit $STATUS
fi

# Install odo
sh packages/odo/fedora_install.sh
STATUS=$?
if [ $STATUS -ne 0 ]
then
    echo "odo failed to install."
    exit $STATUS
fi

# Install Waterfox
sh packages/waterfox/fedora_install.sh
STATUS=$?
if [ $STATUS -ne 0 ]
then
    echo "Waterfox failed to install."
    exit $STATUS
fi

# Install Mailspring
sh packages/mailspring/fedora_install.sh
STATUS=$?
if [ $STATUS -ne 0 ]
then
    echo "Mailspring failed to install."
    exit $STATUS
fi

# Install Etcher
sh packages/etcher/fedora_install.sh
STATUS=$?
if [ $STATUS -ne 0 ]
then
    echo "Etcher failed to install."
    exit $STATUS
fi

# Install Zotero
sh packages/zotero/fedora_install.sh
STATUS=$?
if [ $STATUS -ne 0 ]
then
    echo "Zotero failed to install."
    exit $STATUS
fi

# Install Gradle
sh packages/gradle/fedora_install.sh
STATUS=$?
if [ $STATUS -ne 0 ]
then
    echo "Gradle failed to install."
    exit $STATUS
fi

# Install Leiningen
sh packages/lein/fedora_install.sh
STATUS=$?
if [ $STATUS -ne 0 ]
then
    echo "Leiningen failed to install."
    exit $STATUS
fi

# Add flatpak remotes
flatpak remote-add --if-not-exists flathub "https://flathub.org/repo/flathub.flatpakrepo"

# Install flatpaks
## Install Postman
flatpak install -y flathub com.getpostman.Postman
## Install MakeMKV
flatpak install -y flathub com.makemkv.MakeMKV
## Install OBS Studio
flatpak install -y flathub com.obsproject.Studio
## Install HandBrake
flatpak install -y flathub fr.handbrake.ghb
## Install Skype
flatpak install -y flathub com.skype.Client
## Install AnyDesk
flatpak install -y flathub com.anydesk.Anydesk
## Install Telegram
flatpak install -y flathub org.telegram.desktop
## Install Slack
flatpak install -y flathub com.slack.Slack
