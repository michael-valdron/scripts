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

# Set sdkman installation path if specified
if [ $# -eq 1 ]; then
    export SDKMAN_DIR="${1}"
elif [ $# -gt 1 ]; then
    echo "error: expects 1 optional argument for installation path"
    exit 1
fi

# Install sdkman
echo "Install URL: ${install_script_url}"
echo "Install Path: ${SDKMAN_DIR:-"$HOME/.sdkman (default)"}"
echo "Installing sdkman..."

# Workaround for https://github.com/sdkman/sdkman-cli/issues/1204:
# If using zsh, this script installs using bash shell then inits
# with zsh.
curl -s $install_script_url | bash
if [ $? -ne 0 ]; then
    echo "Error!"
    exit 1
fi
echo "Done!"

echo "Initializing sdkman:"
source "${SDKMAN_DIR:-"$HOME/.sdkman"}/bin/sdkman-init.sh"
if [ $? -ne 0 ]; then
    echo "Error!"
    exit 1
fi
echo "Done!"

echo "sdkman version printout:"
sdk version
if [ $? -ne 0 ]; then
    echo "Error!"
    exit 1
fi
echo "Done!"
