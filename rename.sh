#!/bin/bash

# Enforce root/administrator execution
if [ "$EUID" -ne 0 ]; then
  echo "This script must be run with administrator privileges."
  echo "Requesting sudo privileges..."
  sudo -k
  exec sudo "$0" "$@"
fi


# find .        find in current directory
# -name "*"     find all file names
# -type         of type
# f             file
# d             directory
# |             pipe
# sort -n -r    order files with option -n and -r
# while read    while read all the parameters that comes from the last pipe

# Function to generate a preview of all changes (files only)
generate_preview() {
  echo "========================================================================"
  echo "              PREVIEW OF PENDING FILE NAME CHANGES"
  echo "========================================================================"
  echo
  echo "Files to be renamed:"
  echo "--------------------"
  local files_count=0
  
  # Temporary loop to simulate file renaming
  while read -r file_name; do
    # Skip hidden files/directories (e.g., .git, .DS_Store)
    if [[ "${file_name}" == */.* ]]; then
      continue
    fi
    # Skip the rename and install scripts
    if [[ "${file_name}" == "./rename.sh" || "${file_name}" == "./install.sh" ]]; then
      continue
    fi
    
    first_letter_capitalized=$(echo "${file_name}" | LC_ALL=C awk '{for (i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)} 1')
    processed_file_name=$(echo "${first_letter_capitalized}" | tr ' ' '-' | tr '_' '-')
    
    if [ "${processed_file_name}" != "${file_name}" ]; then
      echo "  [FILE]      ${file_name}  -->  ${processed_file_name}"
      files_count=$((files_count + 1))
    fi
  done < <(find . -name "*" -type f | sort -n -r)
  
  if [ ${files_count} -eq 0 ]; then
    echo "  No files need renaming."
  fi
  echo
  echo "========================================================================"
  echo "                  END OF PREVIEW (Press 'q' to exit)"
  echo "========================================================================"
}

# 1. Display list of changes (scrollable using less/more if available)
if command -v less >/dev/null 2>&1; then
  # -E: Exit less at end of file
  # -X: Do not clear screen on exit
  # -R: Enable raw ANSI color codes if any
  generate_preview | less -E -X -R
elif command -v more >/dev/null 2>&1; then
  generate_preview | more
else
  generate_preview
fi

# 2. Warning and double confirmation check
echo "========================================================================"
echo "WARNING: This script will recursively rename files and directories."
echo "Renaming files/directories can cause issues if other programs, scripts,"
echo "or references are looking for the original file or directory names."
echo "========================================================================"
echo

# First confirmation step
read -p "Step 1 of 2: Are you sure you want to proceed? (yes/no): " confirm1
if [ "$confirm1" != "yes" ]; then
  echo "Aborting script execution."
  exit 0
fi

# Second confirmation step
read -p "Step 2 of 2: This action is permanent and cannot be automatically undone. Continue? (yes/no): " confirm2
if [ "$confirm2" != "yes" ]; then
  echo "Aborting script execution."
  exit 0
fi

echo "Proceeding with renaming..."
echo

# first rename files

find . -name "*" -type f | sort -n -r | while read file_name; do
  # Skip hidden files/directories
  if [[ "${file_name}" == */.* ]]; then
    continue
  fi
  # Skip rename and install scripts
  if [[ "${file_name}" == "./rename.sh" || "${file_name}" == "./install.sh" ]]; then
    continue
  fi
  
  echo "First rename file"
  echo "First letter capitalized ..."
  first_letter_capitalized=$(echo ${file_name} | LC_ALL=C awk '{for (i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)} 1')
  echo "replace empty spaces and underscore with hyphen"
  processed_file_name=$(echo ${first_letter_capitalized} | tr ' ' '-' | tr '_' '-')
  
  if [ "${processed_file_name}" = "${file_name}" ]; then
    echo "${file_name} is a suitable name ... no changes"
  else
    mv "${file_name}" "${processed_file_name}"
    echo "renaming file: ${file_name} to ${processed_file_name}"
  fi
done

# second rename directories

find . -name "*" -type d | sort -n -r | while read directory_name; do
  # Skip current directory and hidden directories
  if [[ "${directory_name}" == "." || "${directory_name}" == */.* ]]; then
    continue
  fi
  
  processed_directory_name=$(echo ${directory_name} | tr ' ' '-' | tr '_' '-' | tr '[a-z]' '[A-Z]')
  if [ "${processed_directory_name}" = "${directory_name}" ]; then
    echo "directory: ${directory_name} is a suitable name ... no changes"
  else
    mv "${directory_name}" "${processed_directory_name}"
    echo "renaming directory: ${directory_name} to ${processed_directory_name}"
  fi
done
