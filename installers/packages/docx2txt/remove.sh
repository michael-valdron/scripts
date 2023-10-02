#!/bin/sh

PIP_CLI=${PIP_CLI:-pip3}

if [ ! "$(command -v ${PIP_CLI})" ]
then
    echo "command \"${PIP_CLI}\" does not exists on system"
    exit 1
elif [ ! "$(command -v docx2txt)" ]
then
    echo "command \"docx2txt\" does not exists on system"
    exit 1
fi

sudo ${PIP_CLI} uninstall -y docx2txt