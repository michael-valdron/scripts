#!/bin/sh

if [ $# -ne 1 ]
then
    echo "error: expecting one argument: sh config_edit.sh <cluster_name>"
    exit 1
fi

if [ -f "${1}.yaml" ]
then
    ${EDITOR} ~/.openshift-install/${1}.yaml
elif [ -f "${1}.yml" ]
then
    ${EDITOR} ~/.openshift-install/${1}.yml
else
    echo "error: unknown cluster profile '${1}'"
    exit 1
fi
