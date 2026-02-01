#!/bin/bash

# Log function used with vendor cleanup function
log() {
    echo "$@"
}

CHECTL_DL_URL='https://che-incubator.github.io/chectl/install.sh'
CHECTL_DL_PATH=${CHECTL_DL_PATH:-'/tmp/chectl-install.sh'}

curl -L ${CHECTL_DL_URL} -o ${CHECTL_DL_PATH}
if [ $? -ne 0 ]
then
    echo "error: problem downloading chectl"
    exit 1
fi

vendor_cleanup_fn_source=$(sed -n '/cleanup_previous_install() {/,/^}/p' ${CHECTL_DL_PATH})
if [ $? -ne 0 ]
then
    echo "error: problem grabbing chectl vendor cleanup function"
    exit
fi

read -p "Please review vendor cleanup function source *before* continuing"
less <<< ${vendor_cleanup_fn_source}

read -p "Good to run? [y/n]: " confirmation
while [[ "${confirmation}" != "y" ]] && [[ "${confirmation}" != "n" ]]
do
    read -p "Please answer 'y' or 'n': " confirmation
done

if [[ "${confirmation}" == "n" ]]
then
    echo "cancelling removal of chectl."
    exit 0
fi

# use log function with sudo
FUNC=$(declare -f log)

echo "Running vendor cleanup function to remove chectl.."
sudo bash -c "${FUNC}; eval \"${vendor_cleanup_fn_source}\" && cleanup_previous_install"
if [ $? -ne 0 ]
then
    echo "error: problem removing chectl with vendor cleanup function"
    exit 1
fi

echo "chectl succussfully removed."
