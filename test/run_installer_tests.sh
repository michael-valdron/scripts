#!/bin/sh

BASE_DIR=$(dirname $0)

echo "Test Fedora Installer.."
sh ${BASE_DIR}/fedora/test.sh ${BASE_DIR}/../installers/fedora_install_packages.sh

# Check if script did not exit properly
if [ $? -ne 0 ]; then
    exit $?
fi

echo "Test Fedora Gaming Installer.."
sh ${BASE_DIR}/fedora/test.sh ${BASE_DIR}/../installers/fedoragaming_install_packages.sh

# Check if script did not exit properly
if [ $? -ne 0 ]; then
    exit $?
fi

echo "Test EL 8 Server Installer.."
sh ${BASE_DIR}/rocky/el8/test.sh ${BASE_DIR}/../installers/server_install_packages.sh

# Check if script did not exit properly
if [ $? -ne 0 ]; then
    exit $?
fi

echo "Test EL 9 Server Installer.."
sh ${BASE_DIR}/rocky/el9/test.sh ${BASE_DIR}/../installers/server_install_packages.sh

# Check if script did not exit properly
if [ $? -ne 0 ]; then
    exit $?
fi

echo "Test Debian Buster Nameserver Installer.."
sh ${BASE_DIR}/debian/buster/test.sh ${BASE_DIR}/../installers/dns_install_packages.sh

# Check if script did not exit properly
if [ $? -ne 0 ]; then
    exit $?
fi

echo "Test Debian Bullseye Nameserver Installer.."
sh ${BASE_DIR}/debian/bullseye/test.sh ${BASE_DIR}/../installers/dns_install_packages.sh

# Check if script did not exit properly
if [ $? -ne 0 ]; then
    exit $?
fi

echo "Test Debian Bookworm Nameserver Installer.."
sh ${BASE_DIR}/debian/bookworm/test.sh ${BASE_DIR}/../installers/dns_install_packages.sh

# Check if script did not exit properly
if [ $? -ne 0 ]; then
    exit $?
fi

echo "Test Debian Bookworm Server Installer.."
sh ${BASE_DIR}/debian/bookworm/test.sh ${BASE_DIR}/../installers/debian_server_install_packages.sh

# Check if script did not exit properly
if [ $? -ne 0 ]; then
    exit $?
fi

echo "Test EL 8 Cloud Installer.."
sh ${BASE_DIR}/rocky/el8/test.sh ${BASE_DIR}/../installers/cloud_install_packages.sh

# Check if script did not exit properly
if [ $? -ne 0 ]; then
    exit $?
fi

echo "Test Manjaro Gaming Installer.."
sh ${BASE_DIR}/archlinux/test.sh ${BASE_DIR}/../installers/manjaro_gaming_install_packages.sh

# Check if script did not exit properly
if [ $? -ne 0 ]; then
    exit $?
fi

echo "All installers completed succussfully!"
