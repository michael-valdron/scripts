#!/bin/sh

CONTAINER_ENGINE=${CONTAINER_ENGINE:-'docker'}

BASE_DIR=$(dirname $0)

echo "Test Fedora Setup Script.."
${CONTAINER_ENGINE} compose -f "${BASE_DIR}/compose.yml" run --rm test-fedora "${BASE_DIR}/../installers/fedora_setup.sh"

# Check if script did not exit properly
if [ $? -ne 0 ]; then
    exit $?
fi

echo "Test Debian Bookworm Setup Script.."
${CONTAINER_ENGINE} compose -f "${BASE_DIR}/compose.yml" run --rm test-debian-bookworm "${BASE_DIR}/../installers/debian_setup.sh"

# Check if script did not exit properly
if [ $? -ne 0 ]; then
    exit $?
fi

echo "Test Debian Bookworm Docker Setup Script.."
${CONTAINER_ENGINE} compose -f "${BASE_DIR}/compose.yml" run --rm test-debian-bookworm "${BASE_DIR}/../installers/debian_docker_setup.sh"

# Check if script did not exit properly
if [ $? -ne 0 ]; then
    exit $?
fi

echo "All setup scripts completed succussfully!"
