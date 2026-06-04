#!/bin/bash

# sync.sh
# Sync the local skills directory with the remote skills repository

# check if parameter is set
if [ $# -ne 1 ]; then
    echo "Usage: $0 <skills directory>"
    echo "Example: $0 .cursor/skills"
    exit 1
fi

GIT_TOKEN=${GIT_TOKEN:-''}
SKILLS_REPO=${SKILLS_REPO:-''}
SKILLS_SUBDIR=${SKILLS_SUBDIR:-'skills'}
SKILLS_DIR=$1

# check if git token is set
if [ -z "${GIT_TOKEN}" ]; then
    echo "GIT_TOKEN is not set"
    exit 1
fi

# check if skills repo is set
if [ -z "${SKILLS_REPO}" ]; then
    echo "SKILLS_REPO is not set"
    exit 1
fi

# create the skills directory if it doesn't exist
mkdir -p "${SKILLS_DIR}"

# inplace git token in skills repo
SKILLS_REPO=${SKILLS_REPO//https\:\/\//https\:\/\/${GIT_TOKEN}\@}

# sync the skills directory with the remote skills repository
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT \
    && git clone --depth 1 --filter=blob:none --sparse "$SKILLS_REPO" "$tmpdir" \
    && git -C "$tmpdir" sparse-checkout set "$SKILLS_SUBDIR" \
    && rsync -a --delete "$tmpdir/$SKILLS_SUBDIR/" "$SKILLS_DIR/"

# check if the sync was successful
if [ $? -ne 0 ]; then
    echo "Failed to sync the skills directory with the remote skills repository"
    exit 1
fi

# print the success message
echo "Skills directory synced successfully"
exit 0

# remove the temporary directory
rm -rf "$tmpdir"
