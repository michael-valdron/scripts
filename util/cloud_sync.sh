#!/bin/sh

SRC_CLOUD_ID=${SRC_CLOUD_ID:-}
DST_CLOUD_ID=${DST_CLOUD_ID:-}
RCLONE_CLI=${RCLONE_CLI:-rclone}

src_path=$1
dst_path=$2

if [ $# -ne 2 ] && [ -z ${src_path} ] && [ -z ${dst_path} ]; then
    echo "Please provide two arguments, sh cloud_sync.sh <src_path> <dst_path>."
    exit 1
elif [ -z ${SRC_CLOUD_ID} ]; then
    echo "Please set SRC_CLOUD_ID to the rclone alias for your cloud source."
    exit 1
elif [ -z ${DST_CLOUD_ID} ]; then
    echo "Please set DST_CLOUD_ID to the rclone alias for your cloud destination."
    exit 1
fi

${RCLONE_CLI} sync --create-empty-src-dirs ${SRC_CLOUD_ID}:${src_path} ${DST_CLOUD_ID}:${dst_path}
