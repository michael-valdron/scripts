#!/bin/sh

if [ -z $KUBECTL_INSTALL_PATH ]
then
    KUBECTL_INSTALL_PATH=$(which kubectl)
    if [ $? -ne 0 ]
    then
        echo "error: kubectl not found on path"
        exit 1
    fi
fi

sudo rm $KUBECTL_INSTALL_PATH
if [ $? -ne 0 ]
then
    echo "error: removal of kubectl failed"
    exit 1
fi
