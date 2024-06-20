#!/bin/sh

OPENSHIFT_INSTALL_DIR=${OPENSHIFT_INSTALL_DIR:-"${HOME}/.openshift-install"}

if [ $# -ne 1 ]
then
    echo "error: expecting one argument: sh config_edit.sh <cluster_name>"
    exit 1
fi

if [ -f "${OPENSHIFT_INSTALL_DIR}/${1}.yaml" ]
then
    ${EDITOR} ${OPENSHIFT_INSTALL_DIR}/${1}.yaml
elif [ -f "${OPENSHIFT_INSTALL_DIR}/${1}.yml" ]
then
    ${EDITOR} ${OPENSHIFT_INSTALL_DIR}/${1}.yml
else
    echo "error: unknown cluster profile '${1}'"
    exit 1
fi
