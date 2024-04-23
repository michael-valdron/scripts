#!/bin/sh

CHECTL_CLI=${CHECTL_CLI:-'chectl'}
CHECTL_PLATFORM=${CHECTL_PLATFORM:-'minikube'}

# Minikube Variables
MINIKUBE_CLI=${MINIKUBE_CLI:-'minikube'}
MINIKUBE_CPUS=${MINIKUBE_CPUS:-'4'}
MINIKUBE_MEM=${MINIKUBE_MEM:-'10240m'}
MINIKUBE_DISK_SIZE=${MINIKUBE_DISK_SIZE:-'50GB'}
MINIKUBE_DRIVER=${MINIKUBE_DRIVER:-'kvm2'}
MINIKUBE_K8S_VERSION=${MINIKUBE_K8S_VERSION:-'v1.23.9'}

# Code Ready Containers Variables
CRC_CLI=${CRC_CLI:-'crc'}
CRC_CPUS=${CRC_CPUS:-'4'}
CRC_MEM=${CRC_MEM:-'10240'}
CRC_DISK_SIZE=${CRC_DISK_SIZE:-'50'}

if [ ! "$(command -v ${CHECTL_CLI})" ]; then
    echo "command \"${CHECTL_CLI}\" does not exists on system"
    exit 1
fi

if [ "${CHECTL_PLATFORM}" == "minikube" ]; then
    if [ ! "$(command -v ${MINIKUBE_CLI})" ]; then
        echo "command \"${MINIKUBE_CLI}\" does not exists on system"
        exit 1
    fi

    ${MINIKUBE_CLI} start --cpus=${MINIKUBE_CPUS} --memory=${MINIKUBE_MEM} --vm=true \
        --disk-size=${MINIKUBE_DISK_SIZE} --kubernetes-version=${MINIKUBE_K8S_VERSION} \
        --driver=${MINIKUBE_DRIVER} --addons=dashboard,ingress
    if [ $? -ne 0 ]; then
        echo "minikube environment failed to start"
        exit 1
    fi
elif [ "${CHECTL_PLATFORM}" == "crc" ]; then
    if [ ! "$(command -v ${CRC_CLI})" ]; then
        echo "command \"${CRC_CLI}\" does not exists on system"
        exit 1
    fi

    ${CRC_CLI} start --cpus ${CRC_CPUS} --memory ${CRC_MEM} --disk-size ${CRC_DISK_SIZE}
    if [ $? -ne 0 ]; then
        echo "Code Ready Containers environment failed to start"
        exit 1
    fi
fi

${CHECTL_CLI} server:deploy --platform ${CHECTL_PLATFORM}
