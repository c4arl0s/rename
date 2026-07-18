#!/bin/bash

# Target script to link
SCRIPT_NAME="rename.sh"
INSTALL_DIR="/usr/local/bin"
LINK_NAME="${INSTALL_DIR}/rename-files"

# Get absolute path of this install script's directory
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TARGET_PATH="${BASE_DIR}/${SCRIPT_NAME}"

# Verify target script exists
if [ ! -f "${TARGET_PATH}" ]; then
  echo "Error: Target script not found at ${TARGET_PATH}"
  exit 1
fi

# Ensure target script is executable
chmod +x "${TARGET_PATH}"

echo "Installing command line tool..."
echo "Target: ${TARGET_PATH}"
echo "Symlink: ${LINK_NAME}"

# Attempt to create the symbolic link, using sudo if write permission is denied
if [ -w "${INSTALL_DIR}" ]; then
  ln -sf "${TARGET_PATH}" "${LINK_NAME}"
else
  echo "Write permission to ${INSTALL_DIR} denied. Requesting administrator privileges..."
  sudo ln -sf "${TARGET_PATH}" "${LINK_NAME}"
fi

if [ $? -eq 0 ] && [ -L "${LINK_NAME}" ]; then
  echo "Success! You can now run 'rename-files' from any directory."
else
  echo "Installation failed."
  exit 1
fi
