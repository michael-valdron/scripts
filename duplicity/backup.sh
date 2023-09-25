#!/bin/sh

DUPLICITY_CMD=${DUPLICITY_CMD:-'duplicity'}
DUPLICITY_ENC_PASSWORD=${DUPLICITY_ENC_PASSWORD:-''}
DUPLICITY_EXCLUDES_FILE=${DUPLICITY_EXCLUDES_FILE:-''}

src_uri=$1
dst_uri=$2
excludes_param_list=()

if [ -z "${src_uri}" ]
then
    echo "parameter 'src_uri' is not specified, usage 'backup.sh <src_uri> <dst_uri>'"
    exit 1
elif [ -z "${dst_uri}" ]
then
    echo "parameter 'dst_uri' is not specified, usage 'backup.sh <src_uri> <dst_uri>'"
    exit 1
fi

if [ ! -z "${DUPLICITY_EXCLUDES_FILE}" ]
then
    if [ ! -f "${DUPLICITY_EXCLUDES_FILE}" ]
    then
        echo "File \"${DUPLICITY_EXCLUDES_FILE}\" does not exists"
        exit 1
    fi    

    excludes_list=($(cat ${DUPLICITY_EXCLUDES_FILE}))
    for exclude_item in ${excludes_list[@]}; do
        excludes_param_list+=("--exclude ${exclude_item}")
    done
fi

if [ ! -z "${DUPLICITY_ENC_PASSWORD}" ]
then
    PASSPHRASE="${DUPLICITY_ENC_PASSWORD}" ${DUPLICITY_CMD} ${src_uri} ${dst_uri} ${excludes_param_list[@]}
else
    ${DUPLICITY_CMD} --no-encryption ${src_uri} ${dst_uri} ${excludes_param_list[@]}
fi
