#!/bin/sh

OPENSHIFT_INSTALL_CLI=${OPENSHIFT_INSTALL_CLI:-openshift-install}
OPENSHIFT_INSTALL_DIR=${OPENSHIFT_INSTALL_DIR:-'~/.openshift-install'}

if [ ! "$(command -v ${OPENSHIFT_INSTALL_CLI})" ]; then
    echo "openshift-install command \"${OPENSHIFT_INSTALL_CLI}\" does not exists on system"
    exit 1
elif [ $# -ne 2 ]; then
    echo "error: expecting two arguments: sh destroy.sh <cmd: cluster> <cluster_name>"
    exit 1
fi

openshift_install_destroy_cli="${OPENSHIFT_INSTALL_CLI} destroy"

case "${1}" in
    1)
        ${openshift_install_destroy_cli} cluster --dir ${OPENSHIFT_INSTALL_DIR}/${2}
    ;;
    *)
        echo "error: not a 'openshift-install destroy' command, expecting 'cluster'"
        exit 1
    ;;
esac
