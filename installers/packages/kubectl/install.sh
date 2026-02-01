#!/bin/sh

if [ -z ${KUBECTL_DL_PATH} ]; then
    KUBECTL_DL_PATH=/tmp/kubectl
fi

if [ -z ${KUBECTL_INSTALL_PATH} ]; then
    KUBECTL_INSTALL_PATH=/usr/local/bin/kubectl
fi

if [ "$(arch)" = "x86_64" ]; then
    arch_platform="amd64"
elif [ "$(arch)" = "arm" ]; then
    arch_platform="arm64"
else
    echo "error: unsupported architecture '$(arch)'"
    exit 1
fi

curl -L https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${arch_platform}/kubectl -o ${KUBECTL_DL_PATH}
if [ $? -ne 0 ]; then
    echo "error: problem downloading kubectl"
    exit 1
fi

curl -L "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${arch_platform}/kubectl.sha256" -o ${KUBECTL_DL_PATH}.sha256
if [ $? -ne 0 ]; then
    echo "error: problem downloading kubectl.sha256"
    exit 1
fi

check=$(echo "$(cat ${KUBECTL_DL_PATH}.sha256) ${KUBECTL_DL_PATH}" | sha256sum --check)
echo $check
if [ "${check}" = "${KUBECTL_DL_PATH}: OK" ]; then
    sudo install -o root -g root -m 0755 ${KUBECTL_DL_PATH} ${KUBECTL_INSTALL_PATH}
else
    echo "error: kubectl is not valid"
    exit 1
fi
