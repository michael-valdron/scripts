#!/bin/sh

OPM_CLI=${OPM_CLI:-'opm'}
JQ_CLI=${JQ_CLI:-'jq'}

catalog_tag=${1}
bundle_tag=${2}
target_tag=${3}

if [ -z "${catalog_tag}" ] && [ -z "${bundle_tag}" ] && [ -z "${target_tag}" ]
then
    echo "error: needs three arguments, sh opm/add.sh <catalog_img_tag> <bundle_img_tag> <target_img_tag>"
    exit 1
fi

catalog_index=$(${OPM_CLI} render ${catalog_tag} -o json | ${JQ_CLI} -s '.')
bundle_index=$(${OPM_CLI} render ${bundle_tag} -o json)
