#!/bin/sh

PKGMGR=${PKGMGR:-''}
YADM_INSTALL_PATH=${YADM_INSTALL_PATH:-"$HOME/.local/bin/yadm"}

POSITIONAL=()
while (( $# > 0 )); do
    case "${1}" in
        -d|--dotfiles)
        if [ -z "${2}" ]; then
            echo "-d|--dotfiles expects value"
            exit 1
        fi
        DOTFILES_REPO="${2}"
        shift
        shift
        ;;
        *) # unknown flag/switch
        POSITIONAL+=("${1}")
        shift
        ;;
    esac
done

set -- "${POSITIONAL[@]}" # restore positional params

install_package() {
    local pkgmgr=$1
    local package_names=${@/$1//}
    
    if [ ! "$(command -v $pkgmgr)" ]; then
        echo "package manager \"$pkgmgr\" does not exist on system"
        exit 1
    fi

    case "$pkgmgr" in
        dnf)
            sudo dnf install -y $package_names
            ;;
        apt)
            sudo apt update -y && sudo apt install $package_names -y
            ;;
        pacman)
            sudo pacman -Sy $package_names
            ;;
        zypper)
            sudo zypper in -y $package_names
            ;;
        *)
            echo "unknown package manager \"$pkgmgr\""
            exit 1
            ;;
    esac
}

if [ -z "${PKGMGR}" ]; then
    # Detect Linux distribution
    if [ -f /etc/os-release ]; then
        # For most modern Linux distributions
        . /etc/os-release
        case "$ID" in
            fedora|rhel|centos)
                PKGMGR='dnf'
                ;;
            opensuse)
                PKGMGR='zypper'
                ;;
            debian|ubuntu)
                PKGMGR='apt'
                ;;
            archlinux)
                PKGMGR='pacman'
                ;;
        esac
    elif [ -f /etc/lsb-release ]; then
        # For older Ubuntu/Debian-based distributions
        PKGMGR='apt'
    elif [ -f /etc/debian_version ]; then
        # Debian-based distributions
        PKGMGR='apt'
    elif [ -f /etc/redhat-release ]; then
        # Red Hat-based distributions (CentOS, Fedora, RHEL)
        PKGMGR='dnf'
    fi
fi

if [ -z "$PKGMGR" ]; then
    echo "no package manager identified, please override PKGMGR to something compatible"
    exit 1
fi

# install git if not installed
if [ ! "$(command -v git)" ]; then
    install_package $PKGMGR git
    if [ $? -ne 0 ]; then
        echo "git failed to install"
        exit 1
    fi
fi

if [ ! -z "$DOTFILES_REPO" ]; then
    # install yadm if not installed
    if [ ! "$(command -v yadm)" ]; then
        git clone https://github.com/yadm-dev/yadm.git $HOME/.yadm-project
        if [ $? -ne 0 ]; then
            echo "failed to clone yadm project"
            exit 1
        fi
        ln -s $HOME/.yadm-project/yadm $YADM_INSTALL_PATH
    fi

    yadm clone $DOTFILES_REPO
fi
