#!/bin/sh

BASE_DIR=$(dirname $0)

echo "Test Fedora Setup Script.."
sh ${BASE_DIR}/fedora/test.sh ${BASE_DIR}/../installers/fedora_setup.sh

# Check if script did not exit properly
if [ $? -ne 0 ]; then
    exit $?
fi

echo "Test EL 8 Setup Script.."
sh ${BASE_DIR}/rocky/el8/test.sh ${BASE_DIR}/../installers/rocky_setup.sh

# Check if script did not exit properly
if [ $? -ne 0 ]; then
    exit $?
fi

echo "Test EL 9 Setup Script.."
sh ${BASE_DIR}/rocky/el9/test.sh ${BASE_DIR}/../installers/rocky_setup.sh

# Check if script did not exit properly
if [ $? -ne 0 ]; then
    exit $?
fi

echo "Test Debian Buster Setup Script.."
sh ${BASE_DIR}/debian/buster/test.sh ${BASE_DIR}/../installers/debian_setup.sh

# Check if script did not exit properly
if [ $? -ne 0 ]; then
    exit $?
fi

echo "Test Debian Bullseye Setup Script.."
sh ${BASE_DIR}/debian/bullseye/test.sh ${BASE_DIR}/../installers/debian_setup.sh

# Check if script did not exit properly
if [ $? -ne 0 ]; then
    exit $?
fi

echo "All setup scripts completed succussfully!"
