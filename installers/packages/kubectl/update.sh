#!/bin/sh

if [ -z ${KUBECTL_DL_PATH} ]
then
    KUBECTL_DL_PATH=/tmp/kubectl
fi

base_dir=$(dirname $0)

if [ "$(arch)" == "x86_64" ]
then
    arch_platform="amd64"
elif [ "$(arch)" == "arm" ]
then
    arch_platform="arm64"
else
    echo "error: unsupported architecture '$(arch)'"
    exit 1
fi

kubectl_install_path=$(which kubectl)
if [ $? -ne 0 ]
then
    echo "error: kubectl not found on path"
    exit 1
fi

kubectl_latest_version=$(curl -L -s https://dl.k8s.io/release/stable.txt)
if [ $? -ne 0 ]
then
    echo "error: problem fetching latest version of kubectl"
    exit 1
fi

kubectl_current_version=$(kubectl version --short | grep 'Client Version: ' | awk -F': ' '{print $2}')
if [ "${kubectl_current_version}" == "${kubectl_latest_version}" ]
then
    echo "Current kubectl version is up to date!"
    exit 0
fi

curl -L https://dl.k8s.io/release/${kubectl_latest_version}/bin/linux/${arch_platform}/kubectl -o ${KUBECTL_DL_PATH}
if [ $? -ne 0 ]
then
    echo "error: problem downloading kubectl"
    exit 1
fi

curl -L "https://dl.k8s.io/${kubectl_latest_version}/bin/linux/${arch_platform}/kubectl.sha256" -o ${KUBECTL_DL_PATH}.sha256
if [ $? -ne 0 ]
then
    echo "error: problem downloading kubectl.sha256"
    exit 1
fi

KUBECTL_INSTALL_PATH=${kubectl_install_path} sh $base_dir/remove.sh
if [ $? -ne 0 ]
then
    exit $?
fi

check=$(echo "$(cat ${KUBECTL_DL_PATH}.sha256) ${KUBECTL_DL_PATH}" | sha256sum --check)
if [ $check == "kubectl: OK" ]
then
    sudo install -o root -g root -m 0755 ${KUBECTL_DL_PATH} $kubectl_install_path
else
    echo "error: kubectl is not valid"
    exit 1
fi
