#!/bin/sh

KERNEL_PACKAGES='kernel kernel-core kernel-devel kernel-devel-matched 
kernel-modules kernel-modules-core kernel-modules-extra'

if [ "$(command -v dnf)" ]; then
	sudo dnf update --exclude="${KERNEL_PACKAGES}" $@
else
	echo "system does not use dnf"
	exit 1
fi

