#!/bin/sh

# Check if hypervisor is installed
if [ -z "$(which virsh)" ]
then
    echo "libvirt is not installed."
    exit 1
# Check if running as root or privileged user
elif [ -z "$(groups | tr ' ' '\n' | grep libvirt)" ] && [ "$EUID" -ne 0 ]
then
    echo "Please run as root or user under 'libvirt' group."
    exit 2
fi

# Variables
base_dir=$(dirname $0)
template_name=$1
vm_name=$2

# Create VM from template
virsh define $base_dir/config/${template_name}.xml 1> /dev/null

# Label VM
virsh domrename ${template_name}-temp ${vm_name} 1> /dev/null

