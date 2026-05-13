#!/bin/sh

CONTAINER_ENGINE=${CONTAINER_ENGINE:-'docker'}

BASE_DIR=$(dirname $0)

UBUNTU_24_04_ENTRYPOINT='sh /scripts/test/entrypoints/ubuntu-24.04-setup-sudo-entrypoint.sh'
DEBIAN_BOOKWORM_ENTRYPOINT='sh /scripts/test/entrypoints/debian-bookworm-setup-sudo-entrypoint.sh'

echo "Test Ubuntu 24.04 Install APT Utility Script.."
if ! ${CONTAINER_ENGINE} compose -f "${BASE_DIR}/compose.yml" run --rm --entrypoint "${UBUNTU_24_04_ENTRYPOINT}" test-ubuntu-24.04 "${BASE_DIR}/../util/apt/install.sh" "--help"; then
    echo 'Failed!'
    exit 1
fi
echo 'Passed!'

echo "Test Debian Bookworm Install APT Utility Script.."
if ! ${CONTAINER_ENGINE} compose -f "${BASE_DIR}/compose.yml" run --rm --entrypoint "${DEBIAN_BOOKWORM_ENTRYPOINT}" test-debian-bookworm "${BASE_DIR}/../util/apt/install.sh" "--help"; then
    echo 'Failed!'
    exit 1
fi
echo 'Passed!'

echo "Test Ubuntu 24.04 Remove APT Utility Script.."
if ! ${CONTAINER_ENGINE} compose -f "${BASE_DIR}/compose.yml" run --rm --entrypoint "${UBUNTU_24_04_ENTRYPOINT}" test-ubuntu-24.04 "${BASE_DIR}/../util/apt/remove.sh" "--help"; then
    echo 'Failed!'
    exit 1
fi
echo 'Passed!'

echo "Test Debian Bookworm Remove APT Utility Script.."
if ! ${CONTAINER_ENGINE} compose -f "${BASE_DIR}/compose.yml" run --rm --entrypoint "${DEBIAN_BOOKWORM_ENTRYPOINT}" test-debian-bookworm "${BASE_DIR}/../util/apt/remove.sh" "--help"; then
    echo 'Failed!'
    exit 1
fi
echo 'Passed!'

echo "Test Ubuntu 24.04 Update APT Utility Script.."
if ! ${CONTAINER_ENGINE} compose -f "${BASE_DIR}/compose.yml" run --rm --entrypoint "${UBUNTU_24_04_ENTRYPOINT}" test-ubuntu-24.04 "${BASE_DIR}/../util/apt/update.sh" "-y"; then
    echo 'Failed!'
    exit 1
fi
echo 'Passed!'

echo "Test Debian Bookworm Update APT Utility Script.."
if ! ${CONTAINER_ENGINE} compose -f "${BASE_DIR}/compose.yml" run --rm --entrypoint "${DEBIAN_BOOKWORM_ENTRYPOINT}" test-debian-bookworm "${BASE_DIR}/../util/apt/update.sh" "-y"; then
    echo 'Failed!'
    exit 1
fi
echo 'Passed!'

echo "Test Ubuntu 24.04 No-Kernel Update APT Utility Script.."
if ! ${CONTAINER_ENGINE} compose -f "${BASE_DIR}/compose.yml" run --rm --entrypoint "${UBUNTU_24_04_ENTRYPOINT}" test-ubuntu-24.04 "${BASE_DIR}/../util/apt/update-nokernel.sh" "-y"; then
    echo 'Failed!'
    exit 1
fi
echo 'Passed!'

echo "Test Debian Bookworm No-Kernel Update APT Utility Script.."
## skipped: Not supported 
# if ! ${CONTAINER_ENGINE} compose -f "${BASE_DIR}/compose.yml" run --rm --entrypoint "${DEBIAN_BOOKWORM_ENTRYPOINT}" test-debian-bookworm "${BASE_DIR}/../util/apt/update-nokernel.sh" "-y"; then
#     echo 'Failed!'
#     exit 1
# fi
# echo 'Passed!'
echo 'Skipped! Not supported.'
