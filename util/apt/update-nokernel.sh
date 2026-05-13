#!/bin/sh

KERNEL_PACKAGES='linux-base linux-firmware linux-generic-hwe-* linux-headers-* linux-hwe-* linux-image-* linux-libc-dev linux-modules-* linux-sound-base linux-tools-*'

if [ "$(command -v apt)" ]; then
	sudo apt update  # Refresh package lists first!
    for p in "${KERNEL_PACKAGES}"; do sudo apt-mark hold $p; done
    sudo apt upgrade $@
    for p in "${KERNEL_PACKAGES}"; do sudo apt-mark unhold $p; done
else
	echo "system does not use apt"
	exit 1
fi
