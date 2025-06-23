#!/usr/bin/env python3
"""
Python Pip Packages Update Script - Version Constraint Updater

This module provides functionality to update version constraints in requirements files.
It replaces exact version constraints (==) with minimum version constraints (>=).
"""

import sys
import os
from typing import Optional
import logging

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


def update_version_constraints(file_path: str, old_constraint: str, new_constraint: str) -> bool:
    """
    Update version constraints in a requirements file.
    
    Args:
        file_path: Path to the requirements file
        old_constraint: The constraint to replace (e.g., "==")
        new_constraint: The new constraint to use (e.g., ">=")
    
    Returns:
        bool: True if successful, False otherwise
    
    Raises:
        FileNotFoundError: If the file doesn't exist
        PermissionError: If the file can't be read/written
    """
    try:
        # Validate file exists
        if not os.path.exists(file_path):
            logger.error(f"File not found: {file_path}")
            return False
        
        # Read the file
        logger.info(f"Reading file: {file_path}")
        with open(file_path, 'r', encoding='utf-8') as file:
            content = file.read()
        
        # Count original occurrences
        original_count = content.count(old_constraint)
        if original_count == 0:
            logger.warning(f"No occurrences of '{old_constraint}' found in {file_path}")
            return True
        
        # Replace constraints
        updated_content = content.replace(old_constraint, new_constraint)
        
        # Count new occurrences
        new_count = updated_content.count(new_constraint)
        
        # Write back to file
        with open(file_path, 'w', encoding='utf-8') as file:
            file.write(updated_content)
        
        logger.info(f"Successfully updated {original_count} constraints from '{old_constraint}' to '{new_constraint}'")
        logger.info(f"File updated: {file_path}")
        
        return True
        
    except FileNotFoundError:
        logger.error(f"File not found: {file_path}")
        return False
    except PermissionError:
        logger.error(f"Permission denied accessing file: {file_path}")
        return False
    except Exception as e:
        logger.error(f"Unexpected error updating file {file_path}: {e}")
        return False


def validate_arguments(args: list) -> tuple[Optional[str], Optional[str], Optional[str]]:
    """
    Validate command line arguments.
    
    Args:
        args: List of command line arguments
    
    Returns:
        tuple: (file_path, old_constraint, new_constraint) or (None, None, None) if invalid
    """
    if len(args) != 3:
        logger.error("Usage: python change.py <file_path> <old_constraint> <new_constraint>")
        logger.error("Example: python change.py requirements.txt '==' '>='")
        return None, None, None
    
    file_path, old_constraint, new_constraint = args
    
    # Basic validation
    if not file_path or not old_constraint or not new_constraint:
        logger.error("All arguments must be non-empty")
        return None, None, None
    
    return file_path, old_constraint, new_constraint


def main() -> int:
    """
    Main function to handle command line execution.
    
    Returns:
        int: Exit code (0 for success, 1 for failure)
    """
    try:
        # Get command line arguments (skip script name)
        args = sys.argv[1:]
        
        # Validate arguments
        file_path, old_constraint, new_constraint = validate_arguments(args)
        if file_path is None:
            return 1
        
        # Update the file
        success = update_version_constraints(file_path, old_constraint, new_constraint)
        
        if success:
            logger.info("Version constraint update completed successfully")
            return 0
        else:
            logger.error("Version constraint update failed")
            return 1
            
    except KeyboardInterrupt:
        logger.info("Operation cancelled by user")
        return 1
    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        return 1


if __name__ == '__main__':
    sys.exit(main())