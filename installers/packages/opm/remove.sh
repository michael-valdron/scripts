#!/bin/sh

if [ -z $OPM_INSTALL_PATH ]
then
    OPM_INSTALL_PATH=$(which opm)
    if [ $? -ne 0 ]
    then
        echo "error: opm not found on path"
        exit 1
    fi
fi

sudo rm $OPM_INSTALL_PATH
if [ $? -ne 0 ]
then
    echo "error: removal of opm failed"
    exit 1
fi
