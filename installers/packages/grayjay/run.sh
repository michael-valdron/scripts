#!/bin/sh

base_dir=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")

cd "${base_dir}" && ./Grayjay
