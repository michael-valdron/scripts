#!/bin/sh

KERNEL_PACKAGES='kernel kernel-core kernel-devel kernel-devel-matched 
kernel-modules kernel-modules-core kernel-modules-extra'
BASE_DIR=$(dirname $0)

sh ${BASE_DIR}/update.sh --exclude=${KERNEL_PACKAGES} $@

