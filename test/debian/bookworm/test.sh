#!/bin/sh

args=($@)

if [ -z "${1}" ]
then
    echo "Please specify script to test."
    exit 1
fi

CONTAINER_ENGINE=${CONTAINER_ENGINE:-docker}
script=$(readlink -f $1)
target_dir=$(dirname $script)
build_path=$(dirname $(readlink -f $0))
img=$USER/$(basename $build_path)
tag="testing"

unset 'args[0]'

# Copy target script to pwd
cp -r $target_dir $build_path/$(basename $target_dir)

# Test build image with target script
${CONTAINER_ENGINE} build --no-cache --force-rm -t $img:$tag \
--build-arg target=$(basename $target_dir) \
--build-arg script=$(basename $script) \
--build-arg args="${args[@]}" \
$build_path

# Set build status code
status=$?

# Remove testing image
${CONTAINER_ENGINE} rmi $img:$tag

# Remove target script from pwd
rm -rf $build_path/$(basename $target_dir)

# Exit with build status code
exit $status
