#!/bin/bash

package_list_alias=$1
output_dir=$2

if [ -f /etc/os-release ]; then
    source /etc/os-release
    case "$ID" in
        debian|ubuntu|mint|linuxmint)
            mkdir -p $output_dir
            dpkg --get-selections > $output_dir/$package_list_alias.list
            ;;
        *)
            echo "linux distro '$ID' not supported yet"
            exit 1
            ;;
    esac
else
    echo "non-linux OS not supported"
    exit 1
fi
