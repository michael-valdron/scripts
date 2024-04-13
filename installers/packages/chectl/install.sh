#!/bin/bash

CHECTL_DL_PATH=${CHECTL_DL_PATH:-'/tmp/chectl-install.sh'}
CHECTL_CHANNEL=${CHECTL_CHANNEL:-'stable'}

echo "Downloading chectl install script.."
curl -L https://www.eclipse.org/che/chectl/ -o ${CHECTL_DL_PATH}
if [ $? -ne 0 ]
then
    echo "error: problem downloading chectl"
    exit 1
fi

echo "Running chectl install script.."
bash ${CHECTL_DL_PATH} --channel=${CHECTL_CHANNEL}
if [ $? -ne 0 ]
then
    echo "error: problem installing chectl"
    exit 1
fi

echo "chectl successfully installed."
