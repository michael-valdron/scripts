#!/bin/bash

GRAYJAY_INSTALL_PATH=${GRAYJAY_INSTALL_PATH:-"$HOME/.var/app/Grayjay.Desktop"}

symlink_path=${HOME}/.local/bin/grayjay

echo -n "Removing shortcut: "
rm $HOME/.local/share/applications/grayjay.desktop
if [ $? -ne 0 ]
then
    echo "error: problem removing shortcut"
    exit 1
fi
echo "Done"

echo -n "Removing symlink: "
rm ${symlink_path}
if [ $? -ne 0 ]
then
    echo "error: problem removing symlink"
    exit 1
fi
echo "Done"

echo -n "Removing Grayjay.Desktop: "
rm -r ${GRAYJAY_INSTALL_PATH}
if [ $? -ne 0 ]
then
    echo "error: problem removing Grayjay.Desktop"
    exit 1
fi
echo "Done"
