#!/bin/bash

# Python Pip Packages Update Script
# A professional script for updating all installed pip packages

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Configuration
readonly SCRIPT_NAME="update.sh"
readonly LOG_FILE="/tmp/pip_update_$(date +%Y%m%d_%H%M%S).log"
readonly BACKUP_FILE="requirements_backup_$(date +%Y%m%d_%H%M%S).txt"
readonly REQUIREMENTS_FILE="requirements.txt"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Logging function
log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE"
}

# Error handling
error_exit() {
    log "ERROR" "$1"
    echo -e "${RED}Error: $1${NC}" >&2
    exit 1
}

# Success message
success() {
    echo -e "${GREEN}$1${NC}"
    log "INFO" "$1"
}

# Warning message
warning() {
    echo -e "${YELLOW}Warning: $1${NC}"
    log "WARNING" "$1"
}

# Info message
info() {
    echo -e "${BLUE}$1${NC}"
    log "INFO" "$1"
}

# Check if pip is available
check_pip() {
    if ! command -v pip &> /dev/null; then
        error_exit "pip is not installed or not in PATH"
    fi
    info "Using pip: $(pip --version)"
}

# Check if Python is available
check_python() {
    if ! command -v python3 &> /dev/null; then
        error_exit "python3 is not installed or not in PATH"
    fi
    info "Using Python: $(python3 --version)"
}

# Backup current requirements
backup_requirements() {
    if [ -f "$REQUIREMENTS_FILE" ]; then
        cp "$REQUIREMENTS_FILE" "$BACKUP_FILE"
        info "Backed up current requirements to: $BACKUP_FILE"
    fi
}

# Generate requirements file
generate_requirements() {
    info "Generating current package list..."
    if ! pip freeze > "$REQUIREMENTS_FILE" 2>/dev/null; then
        error_exit "Failed to generate requirements file"
    fi
    
    local package_count=$(wc -l < "$REQUIREMENTS_FILE")
    info "Found $package_count packages to update"
}

# Update version constraints
update_constraints() {
    if [ -f "change.py" ]; then
        info "Updating version constraints..."
        if ! python3 change.py "$REQUIREMENTS_FILE" "==" ">="; then
            warning "Failed to update version constraints, continuing with original file"
        fi
    else
        warning "change.py not found, using original requirements file"
    fi
}

# Update packages
update_packages() {
    local total_packages=$(wc -l < "$REQUIREMENTS_FILE")
    local current_package=0
    local start_time=$(date +%s)
    local failed_packages=()
    
    info "Starting package updates..."
    
    while IFS= read -r package_line; do
        [ -z "$package_line" ] && continue
        
        current_package=$((current_package + 1))
        local package_name=$(echo "$package_line" | cut -d'=' -f1)
        
        # Calculate progress
        local progress=$((current_package * 100 / total_packages))
        local elapsed_time=$(($(date +%s) - start_time))
        local remaining_packages=$((total_packages - current_package))
        
        # Progress display
        printf "\rProgress: %d%% | Package %d/%d | Remaining: %d | Time: %02d:%02d:%02d" \
               "$progress" "$current_package" "$total_packages" "$remaining_packages" \
               $((elapsed_time / 3600)) $(((elapsed_time % 3600) / 60)) $((elapsed_time % 60))
        
        # Update package
        if pip install --upgrade "$package_name" >/dev/null 2>&1; then
            log "SUCCESS" "Updated: $package_name"
        else
            log "ERROR" "Failed to update: $package_name"
            failed_packages+=("$package_name")
        fi
        
    done < "$REQUIREMENTS_FILE"
    
    echo  # New line after progress
    
    # Report results
    if [ ${#failed_packages[@]} -eq 0 ]; then
        success "All packages updated successfully!"
    else
        warning "Some packages failed to update:"
        for package in "${failed_packages[@]}"; do
            echo "  - $package"
        done
    fi
}

# Cleanup
cleanup() {
    if [ -f "$REQUIREMENTS_FILE" ]; then
        rm -f "$REQUIREMENTS_FILE"
        info "Cleaned up temporary files"
    fi
}

# Main function
main() {
    echo "=========================================="
    echo "    Python Pip Packages Update Script"
    echo "=========================================="
    echo
    
    # Initialize logging
    log "INFO" "Starting pip package update process"
    
    # Pre-flight checks
    check_pip
    check_python
    
    # Main process
    backup_requirements
    generate_requirements
    update_constraints
    update_packages
    
    # Cleanup
    cleanup
    
    # Final message
    local total_time=$(($(date +%s) - start_time))
    success "Update process completed in $(date -d@$total_time -u +%H:%M:%S)"
    info "Log file: $LOG_FILE"
    
    log "INFO" "Update process completed successfully"
}

# Global start time
start_time=$(date +%s)

# Run main function
main "$@"

