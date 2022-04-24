#!/bin/sh

if [ "$EUID" -ne 0 ]
then
    echo "Please run as root"
    exit 1
elif [ -z "${1}" ]
then
    echo "Please provide path to qcow2 file."
    exit 1
elif [ -z "${2}" ]
then
    echo "Please provide partition path on image."
    exit 1
fi

filename=$(basename $1)
mountpoint="/mnt/${SUDO_USER}/${filename%.*}"

if [ ! -d $mountpoint ]; then mkdir -p $mountpoint; fi
guestmount -a $1 -m $2 -o allow_other $mountpoint

if [ $? -ne 0 ]
then
    echo "Problem mounting image to mountpoint ${mountpoint}."
    exit 3
fi

exit 0
