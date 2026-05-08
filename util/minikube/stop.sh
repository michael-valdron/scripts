#!/bin/sh

MINIKUBE_CMD=${MINIKUBE_CMD:-'minikube'}

proxy_pid_file=~/.minikube/proxy.pid

if [ ! "$(command -v ${MINIKUBE_CMD})" ]
then
    echo "command \"${MINIKUBE_CMD}\" does not exist on this system"
    exit 1
fi

if [ -f ${proxy_pid_file} ]
then
    kill $(cat ${proxy_pid_file}) && rm ${proxy_pid_file}
fi

${MINIKUBE_CMD} stop && ${MINIKUBE_CMD} delete
