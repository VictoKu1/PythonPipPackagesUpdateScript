# Python Pip Packages Update Script

A professional and robust script for updating all installed Python pip packages with comprehensive error handling, logging, and user feedback.

## Features

- 🔄 **Automatic Package Updates**: Updates all installed pip packages to their latest versions
- 📊 **Progress Tracking**: Real-time progress display with time estimation
- 📝 **Comprehensive Logging**: Detailed logs for troubleshooting and audit trails
- 🔒 **Error Handling**: Robust error handling with graceful failure recovery
- 💾 **Backup System**: Automatic backup of current requirements before updates
- 🎨 **User-Friendly Interface**: Colored output and clear status messages
- 🛠️ **System Integration**: Easy installation as a system-wide command

## Requirements

- Python 3.x
- pip
- Bash shell
- Root/sudo access (for system-wide installation)

## Installation

### Option 1: One-time Usage

```bash
git clone https://github.com/VictoKu1/PythonPipPackagesUpdateScript.git
cd PythonPipPackagesUpdateScript
chmod +x update.sh
./update.sh
```

### Option 2: System-wide Command Installation

```bash
git clone https://github.com/VictoKu1/PythonPipPackagesUpdateScript.git
cd PythonPipPackagesUpdateScript
sudo ./manager.sh
```

After installation, you can use the `updatePip` command from anywhere in your system.

## Usage

### Direct Script Usage

```bash
# Run the update script directly
./update.sh
```

### System Command Usage

```bash
# Use the installed system command
updatePip
```

### Manager Script Usage

```bash
# Interactive mode
sudo ./manager.sh

# Command line mode
sudo ./manager.sh install    # Install updatePip command
sudo ./manager.sh remove     # Remove updatePip command
```

## What the Script Does

1. **Pre-flight Checks**: Verifies pip and Python are available
2. **Backup Creation**: Creates a backup of current package list
3. **Package Discovery**: Generates a list of all installed packages
4. **Constraint Updates**: Converts exact versions (==) to minimum versions (>=)
5. **Package Updates**: Updates each package individually with progress tracking
6. **Error Reporting**: Reports any failed updates
7. **Cleanup**: Removes temporary files

## Output and Logging

The script provides:
- **Colored output** for different message types (info, warning, error, success)
- **Progress bar** showing completion percentage and time elapsed
- **Detailed logs** saved to `/tmp/pip_update_YYYYMMDD_HHMMSS.log`
- **Backup files** with timestamp for safety

## Safety Features

- **Automatic backups** of current package list
- **Error recovery** - continues updating other packages if one fails
- **Validation** of all inputs and file operations
- **Graceful exit** on errors with helpful messages

## Troubleshooting

### Common Issues

1. **Permission Denied**: Make sure to run with sudo for system-wide installation
2. **Pip Not Found**: Ensure pip is installed and in your PATH
3. **Python Not Found**: Ensure Python 3.x is installed and accessible

### Log Files

Check the log files in `/tmp/` for detailed error information:
```bash
ls -la /tmp/pip_update_*.log
```

### Manual Cleanup

If something goes wrong, you can manually clean up:
```bash
sudo rm -f /usr/local/bin/updatePip
rm -f requirements.txt requirements_backup_*.txt
```

## Contributing

Feel free to submit issues and enhancement requests!

## License

This project is open source and available under the [MIT License](LICENSE).

## Support

If you encounter any issues or have questions, please:
1. Check the log files for detailed error information
2. Review the troubleshooting section above
3. Open an issue on the GitHub repository

---

**Note**: This script updates all installed packages. Use with caution in production environments and consider testing in a virtual environment first.