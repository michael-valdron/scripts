#!/bin/sh

KERNEL_PACKAGES='linux,linux-firmware,***linux-api-headers,linux-firmware***,linux-lts-headers,nvidia-dkms,nvidia-utils,lib32-nvidia-utils'

BASE_DIR=$(dirname $0)

sh $BASE_DIR/update.sh --ignore=${KERNEL_PACKAGES} $@
