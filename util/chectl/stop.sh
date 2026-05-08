#!/bin/sh

CHECTL_CLI=${CHECTL_CLI:-'chectl'}
MINIKUBE_CLI=${MINIKUBE_CLI:-'minikube'}
CRC_CLI=${CRC_CLI:-'crc'}
CHECTL_PLATFORM=${CHECTL_PLATFORM:-'minikube'}

if [ ! "$(command -v ${CHECTL_CLI})" ]; then
    echo "command \"${CHECTL_CLI}\" does not exists on system"
    exit 1
fi

${CHECTL_CLI} server:stop && ${CHECTL_CLI} server:delete -y
if [ $? -ne 0 ]; then
    echo "che failed to stop"
    exit 1
fi

if [ "${CHECTL_PLATFORM}" == "minikube" ]; then
    if [ ! "$(command -v ${MINIKUBE_CLI})" ]; then
        echo "command \"${MINIKUBE_CLI}\" does not exists on system"
        exit 1
    fi

    ${MINIKUBE_CLI} stop && ${MINIKUBE_CLI} delete
elif [ "${CHECTL_PLATFORM}" == "crc" ]; then
    if [ ! "$(command -v ${CRC_CLI})" ]; then
        echo "command \"${CRC_CLI}\" does not exists on system"
        exit 1
    fi

    ${CRC_CLI} stop && ${CRC_CLI} delete -f
fi
