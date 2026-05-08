#!/bin/sh

KUBECTL_CLI=${KUBECTL_CLI:-kubectl}

if [ -z $(which ${KUBECTL_CLI} 2> /dev/null) ] || \
[ ! -f $(which ${KUBECTL_CLI} 2> /dev/null) ]; then
    echo "${KUBECTL_CLI} does not exist"
    exit 1
elif [ $# -ne 2 ]; then
    echo "Expects two arguments, logs.sh <pod_name> <container_name>"
    exit 1
fi

pod_name=$1
container_name=$2

${KUBECTL_CLI} logs ${pod_name} -c ${container_name}
