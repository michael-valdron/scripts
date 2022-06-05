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

# Add Visual Studio Code repository, if not exist
if [ ! -f $YUM_REPOS_DIR/vscode.repo ];
then
    rpm --import "https://packages.microsoft.com/keys/microsoft.asc"
    cp $BASE_DIR/repos/vscode.repo $YUM_REPOS_DIR/vscode.repo
fi

# Add GCP SDK repository, if not exist
if [ ! -f $YUM_REPOS_DIR/google-cloud-sdk.repo ];
then
    cp $BASE_DIR/repos/google-cloud-sdk.repo $YUM_REPOS_DIR/google-cloud-sdk.repo
fi

# Add yadm repository, if not exist
if [ ! -f $YUM_REPOS_DIR/home:TheLocehiliosan:yadm.repo ] && [ ! -f $YUM_REPOS_DIR/yadm.repo ];
then
    cp $BASE_DIR/repos/yadm.repo $YUM_REPOS_DIR/yadm.repo
fi

# Update packages
dnf -y update

# Install packages
dnf -y install neofetch cmatrix tmux htop ufw zsh gcc gcc-c++ curl make cmake go java-11-openjdk clojure code chromium podman podman-docker podman-compose \
    firefox flatpak keepassxc gimp libreoffice calibre xournalpp clamav clamtk vlc sqlitebrowser p7zip p7zip-gui p7zip-plugins cheese @virtualization \
    unzip wget libappindicator redhat-lsb-core google-cloud-sdk bridge-utils openssl duplicity deja-dup ansible kdenlive nodejs npm yarnpkg yadm libguestfs

# Install Minikube
sh $BASE_DIR/packages/minikube/fedora_install.sh
STATUS=$?
if [ $STATUS -ne 0 ]
then
    echo "Minikube failed to install."
    exit $STATUS
fi

# Install odo
sh $BASE_DIR/packages/odo/fedora_install.sh
STATUS=$?
if [ $STATUS -ne 0 ]
then
    echo "odo failed to install."
    exit $STATUS
fi

# Install Waterfox
sh $BASE_DIR/packages/waterfox/fedora_install.sh
STATUS=$?
if [ $STATUS -ne 0 ]
then
    echo "Waterfox failed to install."
    exit $STATUS
fi

# Install Etcher
sh $BASE_DIR/packages/etcher/fedora_install.sh
STATUS=$?
if [ $STATUS -ne 0 ]
then
    echo "Etcher failed to install."
    exit $STATUS
fi

# Install Zotero
sh $BASE_DIR/packages/zotero/fedora_install.sh
STATUS=$?
if [ $STATUS -ne 0 ]
then
    echo "Zotero failed to install."
    exit $STATUS
fi

# Install Gradle
sh $BASE_DIR/packages/gradle/fedora_install.sh
STATUS=$?
if [ $STATUS -ne 0 ]
then
    echo "Gradle failed to install."
    exit $STATUS
fi

# Install Leiningen
sh $BASE_DIR/packages/lein/fedora_install.sh
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
## Install Mailspring
flatpak install -y flathub com.getmailspring.Mailspring
