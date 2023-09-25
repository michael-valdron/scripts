#!/bin/sh

DUPLICITY_CMD=${DUPLICITY_CMD:-'duplicity'}
DUPLICITY_ENC_PASSWORD=${DUPLICITY_ENC_PASSWORD:-''}

src_uri=$1
dst_uri=$2

if [ -z "${src_uri}" ]
then
    echo "parameter 'src_uri' is not specified, usage 'restore.sh <src_uri> <dst_uri>'"
    exit 1
elif [ -z "${dst_uri}" ]
then
    echo "parameter 'dst_uri' is not specified, usage 'restore.sh <src_uri> <dst_uri>'"
    exit 1
fi

if [ ! -z "${DUPLICITY_ENC_PASSWORD}" ]
then
    PASSPHRASE="${DUPLICITY_ENC_PASSWORD}" ${DUPLICITY_CMD} restore ${src_uri} ${dst_uri}
else
    ${DUPLICITY_CMD} restore --no-encryption ${src_uri} ${dst_uri}
fi
