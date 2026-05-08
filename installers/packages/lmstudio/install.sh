#!/bin/bash

# ============================================
# LM STUDIO AUTOMATIC INSTALLER SCRIPT
# ============================================

# --- Configuration ---
DOWNLOAD_DIR="/tmp/lmstudio_download"
INSTALL_BIN="$HOME/.local/bin/lmstudio"
SHARE_DIR="$HOME/.local/share/LM Studio"

# --- Color Definitions ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

function print_status() {
    echo -e "${1}${2}"
}

check_fuse2() {
    local fuse_found=0

    # Debian/Ubuntu (using dpkg)
    if command -v dpkg &> /dev/null; then
        if ! dpkg -s "libfuse2t64" &> /dev/null; then # Check for the specific package name
            print_status "${RED}[!] ERROR:${NC}" "fuse2 is not installed. Please install it manually and rerun the script."
            exit 1
        else
            fuse_found=1
        fi
    # Fedora/CentOS/RHEL (using dnf)
    elif command -v dnf &> /dev/null; then
        if ! dnf list installed "libfuse2" &> /dev/null; then # Check for the specific package name
            print_status "${RED}[!] ERROR:${NC}" "fuse2 is not installed. Please install it manually and rerun the script."
            exit 1
        else
            fuse_found=1
        fi
    # Arch Linux (using pacman)
    elif command -v pacman &> /dev/null; then
        if ! pacman -Qi libfuse2 &> /dev/null; then # Check for the specific package name
            print_status "${RED}[!] ERROR:${NC}" "fuse2 is not installed. Please install it manually and rerun the script."
            exit 1
        else
            fuse_found=1
        fi
    # OpenSUSE (using zypper)
    elif command -v zypper &> /dev/null; then
        if ! zypper info -s libfuse2 &> /dev/null; then # Check for the specific package name
            print_status "${RED}[!] ERROR:${NC}" "fuse2 is not installed. Please install it manually and rerun the script."
            exit 1
        else
            fuse_found=1
        fi
    else
        print_status "${RED}[!] ERROR:${NC}" "Unsupported Linux distribution.  Cannot determine if fuse2 is installed."
        exit 1
    fi

    if [ "$fuse_found" -eq 1 ]; then
      print_status "${GREEN}[+] SUCCESS:${NC}" "fuse2 is installed."
    fi
}


function check_dependencies() {
    echo -e "\n${BLUE}=======================================${NC}"
    echo -e "${YELLOW}STEP 1/6: Checking system prerequisites...${NC}"
    echo -e "${BLUE}---------------------------------------${NC}"

    if ! command -v curl &> /dev/null && ! command -v wget &> /dev/null; then
        print_status "${RED}[!] ERROR:${NC}" "This script requires 'curl' or 'wget'. Please install one using your package manager (e.g., sudo apt install curl)."
        exit 1
    fi

    # Check for fuse2
    check_fuse2

    # Ensure the target binary directory exists
    if [ ! -d "$HOME/.local/bin" ]; then
        print_status "${YELLOW}[!] WARNING:${NC}" "The standard binary folder ($HOME/.local/bin) does not exist. Creating it now."
        mkdir -p "$HOME/.local/bin"
    fi

    # Ensure the share directory exists
    if [ ! -d "$SHARE_DIR" ]; then
        print_status "${YELLOW}[!] WARNING:${NC}" "The shared folder ($SHARE_DIR) does not exist. Creating it now."
        mkdir -p "$SHARE_DIR"
    fi
}


function download_appimage() {
    echo -e "\n${BLUE}=======================================${NC}"
    echo -e "${YELLOW}STEP 2/5: Downloading LM Studio AppImage...${NC}"
    echo -e "${BLUE}---------------------------------------${NC}"

    mkdir -p "$DOWNLOAD_DIR"
    curl -L "https://lmstudio.ai/download/latest/linux/x64" -o "$DOWNLOAD_DIR/lmstudio.AppImage"

    if [ $? -eq 0 ]; then
        print_status "${GREEN}[+] SUCCESS:${NC}" "LM Studio AppImage downloaded successfully."
        return 0
    else
        print_status "${RED}[!] ERROR:${NC}" "Failed to download the AppImage. Please check your internet connection and try again."
        exit 1
    fi
}

function setup_permissions() {
    echo -e "\n${BLUE}=======================================${NC}"
    echo -e "${YELLOW}STEP 3/5: Setting up permissions...${NC}"
    echo -e "${BLUE}---------------------------------------${NC}"

    chmod +x "$DOWNLOAD_DIR/lmstudio.AppImage"

    if [ $? -eq 0 ]; then
        print_status "${GREEN}[+] SUCCESS:${NC}" "Permissions set. The file is now executable."
        return 0
    else
        print_status "${RED}[!] ERROR:${NC}" "Failed to set execute permissions. Check directory write access."
        exit 1
    fi
}

function install_and_link() {
    echo -e "\n${BLUE}=======================================${NC}"
    echo -e "${YELLOW}STEP 4/5: Installing and linking the binary...${NC}"
    echo -e "${BLUE}---------------------------------------${NC}"

    mv "$DOWNLOAD_DIR/lmstudio.AppImage" "$SHARE_DIR/"

    ln -s "$SHARE_DIR/lmstudio.AppImage" "$INSTALL_BIN"

    if [ $? -eq 0 ]; then
        print_status "${GREEN}[+] SUCCESS:${NC}" "Installation complete!"
        print_status "${YELLOW}The binary is now available globally at: ${BLUE}$INSTALL_BIN${NC}"
        return 0
    else
        print_status "${RED}[!] FATAL ERROR:${NC}" "Could not create the symbolic link. Manual cleanup may be required."
        exit 1
    fi
}

function cleanup() {
    echo -e "\n${BLUE}=======================================${NC}"
    echo -e "${YELLOW}STEP 5/5: Cleaning up temporary files...${NC}"
    echo -e "${BLUE}---------------------------------------${NC}"
    rm -rf "$DOWNLOAD_DIR"
    if [ $? -eq 0 ]; then
        print_status "${GREEN}[+] SUCCESS:${NC}" "Cleanup finished. You are ready to run LM Studio!"
    else
        print_status "${YELLOW}[!] WARNING:${NC}" "Could not delete the temporary directory ($DOWNLOAD_DIR). Please remove it manually if needed."
    fi
}

# ============================================
# MAIN EXECUTION FLOW
# ============================================

echo -e "\n${BLUE}\033[1m=== LM STUDIO INSTALLATION STARTING ===\033[0m"

check_dependencies
download_appimage
setup_permissions
install_and_link
cleanup

echo -e "\n${BLUE}\033[1m========================================\033[0m"
print_status "${GREEN}✨ INSTALLATION COMPLETE! ✨${NC}"
echo -e "To run LM Studio, simply open your terminal and type:"
echo -e "${YELLOW}$INSTALL_BIN${NC}"
echo -e "\nEnjoy running local LLMs!"
