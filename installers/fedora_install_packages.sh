#!/bin/sh

# Check if running as root
if [ "$EUID" -ne 0 ]
then 
    echo "Please run as root"
    exit 1
fi

yum_repos_dir=/etc/yum.repos.d
base_dir=$(dirname $0)

# Run base setup
sh $base_dir/fedora_setup.sh 1

# Add Visual Studio Code repository, if not exist
if [ ! -f $yum_repos_dir/vscode.repo ];
then
    rpm --import "https://packages.microsoft.com/keys/microsoft.asc"
    cp $base_dir/repos/vscode.repo $yum_repos_dir/vscode.repo
fi

# Add GCP SDK repository, if not exist
if [ ! -f $yum_repos_dir/google-cloud-sdk.repo ];
then
    cp $base_dir/repos/google-cloud-sdk.repo $yum_repos_dir/google-cloud-sdk.repo
fi

# Add yadm repository, if not exist
if [ ! -f $yum_repos_dir/home:TheLocehiliosan:yadm.repo ] && [ ! -f $yum_repos_dir/yadm.repo ];
then
    cp $base_dir/repos/yadm.repo $yum_repos_dir/yadm.repo
fi

# Remove packages
dnf -y remove libreoffice-core

# Update packages
dnf -y update

# Install dependencies
dnf -y install jq which

# Install packages
if [ -f "${base_dir}/packages/${1}.rpm.json" ];
then

    dnf -y install $((<$base_dir/packages/${1}.rpm.json jq -r '.[].id | @sh') | tr -d \')

else
    echo "No RPM list exists for profile '${1}', skipping RPM install."
fi

# Install flatpaks
if [ -z "$(which flatpak 2> /dev/null)" ];
then
    echo "flatpak is not installed, skipping flatpak install."
elif [ -f "${base_dir}/packages/${1}.flatpak.json" ];
then
    # Add flatpak remotes
    flatpak remote-add --if-not-exists flathub "https://flathub.org/repo/flathub.flatpakrepo"

    flatpaks=($((<$base_dir/packages/${1}.flatpak.json jq -r '.[] | .source, .id') | tr -d \'))
    i=0
    while [ $i -lt ${#flatpaks[@]} ]
    do
        echo "Installing ${flatpaks[$i+1]} flatpak from ${flatpaks[$i]}..."
        flatpak install -y ${flatpaks[$i]} ${flatpaks[$i+1]}
        i=$((i+2))
    done
else
    echo "No flatpaks list exists for profile '${1}', skipping flatpak install."
fi
