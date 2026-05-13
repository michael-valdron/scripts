#!/bin/sh

CONTAINER_ENGINE=${CONTAINER_ENGINE:-'docker'}

BASE_DIR=$(dirname $0)

echo "Test Fedora Installer.."
${CONTAINER_ENGINE} compose -f "${BASE_DIR}/compose.yml" run --rm test-fedora "${BASE_DIR}/../installers/fedora_install_packages.sh"

# Check if script did not exit properly
if [ $? -ne 0 ]; then
    exit $?
fi

echo "Test Fedora Gaming Installer.."
${CONTAINER_ENGINE} compose -f "${BASE_DIR}/compose.yml" run --rm test-fedora "${BASE_DIR}/../installers/fedoragaming_install_packages.sh"

# Check if script did not exit properly
if [ $? -ne 0 ]; then
    exit $?
fi

echo "Test Debian Bookworm Nameserver Installer.."
${CONTAINER_ENGINE} compose -f "${BASE_DIR}/compose.yml" run --rm test-debian-bookworm "${BASE_DIR}/../installers/dns_install_packages.sh"

# Check if script did not exit properly
if [ $? -ne 0 ]; then
    exit $?
fi

echo "Test Debian Bookworm Server Installer.."
${CONTAINER_ENGINE} compose -f "${BASE_DIR}/compose.yml" run --rm test-debian-bookworm "${BASE_DIR}/../installers/debian_server_install_packages.sh"

# Check if script did not exit properly
if [ $? -ne 0 ]; then
    exit $?
fi

echo "Test Manjaro Gaming Installer.."
${CONTAINER_ENGINE} compose -f "${BASE_DIR}/compose.yml" run --rm test-archlinux ${BASE_DIR}/../installers/manjaro_gaming_install_packages.sh

# Check if script did not exit properly
if [ $? -ne 0 ]; then
    exit $?
fi

echo "All installers completed succussfully!"
