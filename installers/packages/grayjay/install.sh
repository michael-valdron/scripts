#!/bin/bash

base_dir=$(dirname $0)
os_name=$(uname -s | awk '{print tolower($0)}')
arch_platform=$(arch)
symlink_path=${HOME}/.local/bin/grayjay
if [ "${arch_platform}" != "x86_64" ]
then
    echo "error: unsupported architecture '${arch_platform}'"
    exit 1
fi

if [ "${os_name}" != "linux" ]
then
    echo "error: unsupported operating system '${os_name}'"
    exit 1
fi

GRAYJAY_DL_PATH=${GRAYJAY_DL_PATH:-"/tmp/Grayjay.Desktop-${arch_platform/86_/}.zip"}
GRAYJAY_INSTALL_PATH=${GRAYJAY_INSTALL_PATH:-"$HOME/.var/app/Grayjay.Desktop"}

echo "Downloading Grayjay.Desktop: "
curl -L --progress-bar https://updater.grayjay.app/Apps/Grayjay.Desktop/Grayjay.Desktop-${os_name}-${arch_platform/86_/}.zip -o ${GRAYJAY_DL_PATH}
if [ $? -ne 0 ]
then
    echo "error: problem downloading Grayjay.Desktop"
    exit 1
fi

echo -n "Checking downloaded version: "
grayjay_version="$([[ "$(unzip -l ${GRAYJAY_DL_PATH} | grep 'Grayjay.Desktop-linux-x64-v' | head -1)" =~ v[0-9]+ ]] && echo ${BASH_REMATCH[0]})"
grayjay_version=${grayjay_version:1}
echo "v${grayjay_version}"

echo -n "Installing Grayjay.Desktop: "
unzip -q ${GRAYJAY_DL_PATH} -d ${GRAYJAY_INSTALL_PATH} && \
    mv ${GRAYJAY_INSTALL_PATH}/Grayjay.Desktop-${os_name}-${arch_platform/86_/}-v${grayjay_version}/* ${GRAYJAY_INSTALL_PATH} && \
    rm -rf ${GRAYJAY_INSTALL_PATH}/Grayjay.Desktop-${os_name}-${arch_platform/86_/}-v${grayjay_version} && \
    cp $base_dir/run.sh ${GRAYJAY_INSTALL_PATH}/run.sh && \
    chmod u+x ${GRAYJAY_INSTALL_PATH}/run.sh
if [ $? -ne 0 ]
then
    echo "error: problem installing Grayjay.Desktop"
    exit 1
fi
echo "Done"

if [ ! -f "${symlink_path}" ]
then
    echo -n "Creating symlink: "
    ln -s ${GRAYJAY_INSTALL_PATH}/run.sh ${symlink_path}
    if [ $? -ne 0 ]
    then
        echo "error: problem creating symlink"
        exit 1
    fi
    echo "Done"
fi

echo -n "Creating shortcut: "
echo "$(cat $base_dir/grayjay.desktop | sed "s/\/path\/to\/exec/${symlink_path//\//\\\/}/g" | sed "s/\/path\/to\/icon/${GRAYJAY_INSTALL_PATH//\//\\\/}\/logo.ico/g")" > $HOME/.local/share/applications/grayjay.desktop
if [ $? -ne 0 ]
then
    echo "error: problem creating shortcut"
    exit 1
fi
echo "Done"
