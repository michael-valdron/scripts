#!/bin/sh

install_script_url=https://get.sdkman.io

POSITIONAL=()
while (( $# > 0 )); do
    case "${1}" in
        -n|--no-shell)
        install_script_url="${install_script_url}?rcupdate=false"
        shift # shift once since flags have no values
        ;;
        -*|--*) # unknown flag/switch
        echo "error: unknown flag argument"
        exit 1
        ;;
        *) # positional
        POSITIONAL+=("${1}")
        shift
        ;;
    esac
done

set -- "${POSITIONAL[@]}" # restore positional params

# Read installation script
echo "Reading from ${install_script_url}..."
curl -s $install_script_url | less
if [ $? -ne 0 ]; then
    echo "Error!"
    exit 1
fi
echo "Done!"