#!/bin/sh

CONTAINER_ENGINE=${CONTAINER_ENGINE:-'docker'}

BASE_DIR=$(dirname $0)

ARCHLINUX_ENTRYPOINT='sh /scripts/test/entrypoints/archlinux-setup-sudo-entrypoint.sh'

echo "Test Install pacman Utility Script.."
if ! ${CONTAINER_ENGINE} compose -f "${BASE_DIR}/compose.yml" run --rm --entrypoint "${ARCHLINUX_ENTRYPOINT}" test-archlinux "${BASE_DIR}/../util/pacman/install.sh" "--noconfirm" "fastfetch"; then
    echo 'Failed!'
    exit 1
fi
echo 'Passed!'

echo "Test Remove pacman Utility Script.."
if ! ${CONTAINER_ENGINE} compose -f "${BASE_DIR}/compose.yml" run --rm --entrypoint "${ARCHLINUX_ENTRYPOINT}" test-archlinux "${BASE_DIR}/../util/pacman/remove.sh" "--noconfirm" "sudo"; then
    echo 'Failed!'
    exit 1
fi
echo 'Passed!'

echo "Test Update pacman Utility Script.."
if ! ${CONTAINER_ENGINE} compose -f "${BASE_DIR}/compose.yml" run --rm --entrypoint "${ARCHLINUX_ENTRYPOINT}" test-archlinux "${BASE_DIR}/../util/pacman/update.sh" "--noconfirm"; then
    echo 'Failed!'
    exit 1
fi
echo 'Passed!'

echo "Test No-Kernel Update pacman Utility Script.."
if ! ${CONTAINER_ENGINE} compose -f "${BASE_DIR}/compose.yml" run --rm --entrypoint "${ARCHLINUX_ENTRYPOINT}" test-archlinux "${BASE_DIR}/../util/pacman/update-nokernel.sh" "--noconfirm"; then
    echo 'Failed!'
    exit 1
fi
echo 'Passed!'
