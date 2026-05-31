#!/bin/bash

# ============================================
# LM STUDIO AUTOMATIC UNINSTALLER SCRIPT
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


function remove_symlink() {
  echo -e "\n${BLUE}=======================================${NC}"
  echo -e "${YELLOW}STEP 1/4: Removing symbolic link...${NC}"
  echo -e "${BLUE}---------------------------------------${NC}"

  rm "$INSTALL_BIN"
  if [ $? -eq 0 ]; then
    print_status "${GREEN}[+] SUCCESS:${NC}" "Symbolic link removed."
    return 0
  else
    print_status "${RED}[!] ERROR:${NC}" "Failed to remove symbolic link. It may not exist, or you might lack permissions."
    exit 1
  fi
}

function remove_appimage() {
  echo -e "\n${BLUE}=======================================${NC}"
  echo -e "${YELLOW}STEP 2/4: Removing AppImage...${NC}"
  echo -e "${BLUE}---------------------------------------${NC}"

  rm "$SHARE_DIR/lmstudio.AppImage"
  if [ $? -eq 0 ]; then
    print_status "${GREEN}[+] SUCCESS:${NC}" "AppImage removed."
    return 0
  else
    print_status "${RED}[!] ERROR:${NC}" "Failed to remove AppImage. It may not exist, or you might lack permissions."
    exit 1
  fi
}

function remove_share_directory() {
  echo -e "\n${BLUE}=======================================${NC}"
  echo -e "${YELLOW}STEP 3/4: Removing share directory...${NC}"
  echo -e "${BLUE}---------------------------------------${NC}"

  rm -rf "$SHARE_DIR"
  if [ $? -eq 0 ]; then
    print_status "${GREEN}[+] SUCCESS:${NC}" "Share directory removed."
    return 0
  else
    print_status "${RED}[!] ERROR:${NC}" "Failed to remove share directory. You may lack permissions or it might be in use."
    exit 1
  fi
}

function remove_desktop_file() {
    echo -e "\n${BLUE}=======================================${NC}"
    echo -e "${YELLOW}STEP 4/5: Removing desktop file...${NC}"
    echo -e "${BLUE}---------------------------------------${NC}"

    DESKTOP_FILE="$HOME/.local/share/applications/lmstudio.desktop"

    if [ -f "$DESKTOP_FILE" ]; then
      rm "$DESKTOP_FILE"
      if [ $? -eq 0 ]; then
          print_status "${GREEN}[+] SUCCESS:${NC}" "Desktop file '$DESKTOP_FILE' removed."
      else
          print_status "${RED}[!] ERROR:${NC}" "Failed to remove the desktop file. Check permissions and ensure the directory exists."
          return 1 # Indicate failure
      fi
    else
      print_status "${BLUE}[i] SKIPPED:${NC}" "No desktop file found."
    fi
}

function cleanup() {
  echo -e "\n${BLUE}=======================================${NC}"
  echo -e "${YELLOW}STEP 5/5: Final Cleanup...${NC}"
  echo -e "${BLUE}---------------------------------------${NC}"

  if [ -d "$DOWNLOAD_DIR" ]; then
    rm -rf "$DOWNLOAD_DIR"
    if [ $? -eq 0 ]; then
      print_status "${GREEN}[+] SUCCESS:${NC}" "Download directory removed."
      return 0
    else
      print_status "${RED}[!] ERROR:${NC}" "Failed to remove download directory. You might lack permissions."
      exit 1
    fi
  fi

  print_status "${GREEN}[+] SUCCESS:${NC}" "Uninstallation complete."
}


# ============================================
# MAIN EXECUTION FLOW
# ============================================

echo -e "\n${BLUE}\033[1m=== LM STUDIO UNINSTALLATION STARTING ===${NC}"

remove_symlink
remove_appimage
remove_share_directory
remove_desktop_file
cleanup

echo -e "\n${BLUE}\033[1m========================================${NC}"
print_status "${GREEN}✨ UNINSTALLATION COMPLETE! ✨${NC}"
