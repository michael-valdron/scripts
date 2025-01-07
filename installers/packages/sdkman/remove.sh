#!/bin/sh

# Set sdkman installation path if specified
if [ $# -eq 1 ]; then
    SDKMAN_DIR="${1}"
elif [ $# -eq 0 ]; then
    SDKMAN_DIR="${HOME}/.sdkman"
else
    echo "error: expects 1 optional argument for installation path"
    exit 1
fi

# Remove installation
echo -n "Removing sdkman: "
rm -rf $SDKMAN_DIR
if [ $? -ne 0 ]; then
    echo "Error!"
    exit 1
fi
echo "Done!"

# Remove shell config
echo -n "Removing shell config: "
sed -i '/THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK/{N;N;d}' $HOME/.zshrc $HOME/.bashrc $HOME/.bash_profile $HOME/.profile
if [ $? -ne 0 ]; then
    echo "Error!"
    exit 1
fi
echo "Done!"
