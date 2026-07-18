# Rename Files & Directories

A Bash script utility designed to recursively rename files and directories in a given path to enforce clean, consistent naming conventions.

## Features

- **Recursive Renaming**: Searches the entire directory tree from the target root folder.
- **Sorted Traversal**: Uses `sort -n -r` to ensure files and nested items are renamed before their parent directories, preventing paths from breaking mid-execution.
- **File Renaming Rules**:
  - Capitalizes the first letter of each word in the file name.
  - Replaces spaces (` `) and underscores (`_`) with hyphens (`-`).
- **Directory Renaming Rules**:
  - Converts all characters to UPPERCASE.
  - Replaces spaces (` `) and underscores (`_`) with hyphens (`-`).

## How It Works

The script is located at [rename.sh](file:///Users/carlossantiagocruz/iOS-Projects/rename/rename.sh).

### 1. Renaming Files
First, the script queries all files (`-type f`) under the target directory, sorts them in reverse name order, and processes each:
- Converts the first letter of each word to uppercase using `awk`.
- Replaces spaces and underscores with hyphens using `tr`.
- Performs the rename (`mv`) if the new name differs from the original.

### 2. Renaming Directories
Next, the script queries all directories (`-type d`), sorts them in reverse order, and processes each:
- Transforms the folder name to all uppercase.
- Replaces spaces and underscores with hyphens.
- Performs the rename (`mv`) if the new name differs from the original.

## Installation

You can install the tool globally so that it's accessible as the `rename-files` command from any directory on your system.

An installation script [install.sh](file:///Users/carlossantiagocruz/iOS-Projects/rename/install.sh) is provided for this purpose. It creates a symbolic link to the actual script in `/usr/local/bin`.

To install:
```bash
./install.sh
```

*(Note: If write permission to `/usr/local/bin` is not present, the script will prompt for `sudo` to complete the action.)*

## Usage

> [!IMPORTANT]
> - **Execution Path Limitation**: For safety, this script can **only** be executed if the current working directory is inside your `$HOME` directory or its subdirectories. It will explicitly block runs in system directories (such as `/usr/local/bin`, `/etc`, etc.) to prevent accidental renaming of system files.
> - **Administrator Privileges**: This script must be run with administrator (root) privileges. If run directly, it will prompt you for your `sudo` password and restart itself with elevated privileges. The script invalidates cached `sudo` credentials on start to guarantee a password prompt is shown on every execution.

If installed globally:
```bash
rename-files
```

If running locally:
1. **Navigate to the target directory** (or place the script in the parent directory where you want to rename files).
2. **Make the script executable** (if necessary):
   ```bash
   chmod +x rename.sh
   ```
3. **Run the script**:
   ```bash
   ./rename.sh
   ```

### Preview & Confirmation Steps

To prevent accidental runs, the script features a preview stage followed by a double confirmation safety check:
1. **Interactive Preview**: Before any changes are made, it displays a scrollable preview listing all the files that will be renamed (using `less` or `more` to allow scrolling and review). Press `q` to exit the preview.

2. **Safety Warning**: Displays a warning regarding potential program/script reference breakage.
3. **First Confirmation**: Prompts you to confirm proceeding (`yes` / `no`).
4. **Second Confirmation**: Prompts you a second time to confirm the permanent, in-place nature of the renaming process (`yes` / `no`).


> [!WARNING]
> This script performs in-place renaming using the `mv` command. Make sure you have a backup of your directories or that your project is committed to version control (e.g., Git) before executing the script, as changes cannot be easily undone.

