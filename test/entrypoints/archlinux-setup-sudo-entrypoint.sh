#!/bin/sh

# make sure sudo is installed
echo '[Entrypoint]: Installing sudo..'
if ! pacman -Sy --noconfirm sudo; then
    echo 'Failed'
    exit 1
fi
echo 'Done!'

# make sure no password is needed to run sudo
# echo -n '[Entrypoint]: Enabling passwordless sudo.. '
# if ! echo "$USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers; then
#     echo 'Failed'
#     exit 1
# fi
# echo 'Done!'

# Run command
echo '[Entrypoint]: Running given command..'
if ! sh $@; then
    exit 1
fi
echo 'Completed!'
