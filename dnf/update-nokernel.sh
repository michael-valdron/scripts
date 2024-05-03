#!/bin/sh

BASE_DIR=$(dirname $0)

sh ${BASE_DIR}/update.sh --exclude="kernel kernel-core kernel-devel kernel-devel-matched kernel-modules kernel-modules-core kernel-modules-extra" $@
