#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Post-generation script for cookiecutter template.
This script handles license selection and other post-generation tasks.
"""

import os
import shutil
from pathlib import Path

# Get the license selected by the user
license_name = "{{ cookiecutter.license }}"

# Define the path to the license files
license_dir = Path("_licenses")
license_source = license_dir / f"{license_name}.txt"
license_dest = Path("LICENSE")

# Copy the selected license file
if license_source.exists():
    shutil.copy2(license_source, license_dest)
    print(f"Copied license file: {license_name}")
else:
    print(f"Warning: License file not found: {license_source}")

# Remove the licenses directory
if license_dir.exists() and license_dir.is_dir():
    shutil.rmtree(license_dir)
    print("Removed licenses directory")
