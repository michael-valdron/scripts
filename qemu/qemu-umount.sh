#!/bin/sh

if [ "$EUID" -ne 0 ]
then
    echo "Please run as root"
    exit 1
elif [ -z "${1}" ]
then
    echo "Please provide path to qcow2 file or mountpoint."
    exit 1
fi

filename=$(basename $1)
mountpoint="/mnt/${SUDO_USER}/${filename%.*}"

guestunmount $mountpoint
if [ $? -ne 0 ]
then
    echo "Problem unmount mountpoint ${mountpoint}."
    exit 2
fi

rm -rf $mountpoint
