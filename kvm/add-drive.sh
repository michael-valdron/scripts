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

# Set pool to default path 
if [ -z "${IMAGE_POOL}" ]
then
    if [ "$EUID" -ne 0 ]
    then
        echo "Please run as root."
        exit 2
    fi
    IMAGE_POOL=$(virsh pool-dumpxml default | awk -F'[<>]' '/path/ {print $3}')
fi

# Variables
base_dir=$(dirname $0)
vm_name=$1
image_uri=$2
new_dev=$3

# Read in array of current VMs
read -r -a vms <<< "$(virsh list --name --all | tr '\n' ' ')"

# Find specified VM
vm_found=0
for vm in ${vms[@]}
do
    if [ "${vm}" == "${vm_name}" ]
    then
        vm_found=1
        break
    fi
done

# Throw error if specified VM is not found
if [[ $vm_found -ne 1 ]]
then
    echo "'${vm_name}' does not exist."
    exit 3
fi

# Select target bus based on target device name, error if 
# device name prefix does not match a compatible bus.
if [[ $new_dev = vd* ]]
then
    targetbus=virtio
elif [[ $new_dev = sd* ]]
then
    targetbus=sata
else
    echo "dev prefix '${new_dev:0:2}' is not valid."
    exit 4
fi

# If uri to disk image is a local path append the file:// to uri (if not already there)
if [[ ! $image_uri = http://* ]] && [[ ! $image_uri = https://* ]] && [[ ! $image_uri = file://* ]]
then
    image_uri=$([[ $image_uri = /* ]] && echo "file://${image_uri}" || echo "file://${PWD}/${image_uri}")
fi

# Read all devices with same prefix as specified name for the new device
read -r -a existing_dev <<< "$(virsh domblklist ${vm_name} | awk '{print $1}' | grep -e ${new_dev:0:2} | tr '\n' ' ')"

# Check if specified device name match any existing ones, if so throw error to user
for dev in ${existing_dev[@]}
do
    if [ "${dev}" == "${new_dev}" ]
    then
        echo "'${new_dev}' already exists, please specific disk target labeled past '${existing_dev[-1]}'."
        exit 5
    fi
done

# Make image path, /path/to/pool/{vm-name}_{random-hash-string}.qcow2
disk_path=${IMAGE_POOL}/${vm_name}_$(echo ${RANDOM} | md5sum | head -c 15; echo;).qcow2

# If disk path exists, regenerate a new until it does not exist
while [ -f $disk_path ]
do
    disk_path=${IMAGE_POOL}/${vm_name}_$(echo ${RANDOM} | md5sum | head -c 15; echo;).qcow2
done

# Download / Copy template disk image from uri to disk path
curl -L $image_uri -o $disk_path

# Attach disk at disk path to the vm specified
virsh attach-disk $vm_name $disk_path $new_dev --persistent --driver=qemu --subdriver=qcow2 --targetbus=$targetbus
