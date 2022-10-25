#!/bin/sh

if [ -z "${1}" ]
then
    echo "Please specify script to test."
    exit 1
fi

SCRIPT=$(readlink -f $1)
TARGET_DIR=$(dirname $SCRIPT)
BUILD_PATH=$(dirname $(readlink -f $0))
IMG=$USER/$(basename $BUILD_PATH)
TAG="testing"

# Copy target script to pwd
cp -r $TARGET_DIR $BUILD_PATH/$(basename $TARGET_DIR)

# Test build image with target script
docker build --no-cache --force-rm -t $IMG:$TAG \
--build-arg target=$(basename $TARGET_DIR) \
--build-arg script=$(basename $SCRIPT) \
$BUILD_PATH

# Set build status code
STATUS=$?

# Remove testing image
docker rmi $IMG:$TAG

# Remove target script from pwd
rm -rf $BUILD_PATH/$(basename $TARGET_DIR)

# Exit with build status code
exit $STATUS
