#!/bin/sh

set -e
set -o pipefail

# Print the Input Variables
__inputs="
    Policies Directory: $INPUT_POLICIES_DIR
    Path to Terraform Plan: $INPUT_TFPLAN_JSON
    Additonal Data Files: $INPUT_ADDITIONAL_DATA_FILES
    Additonal Configuration Files: $INPUT_DATA_FILES
    OPA Debug Mode: $INPUT_ADDITIONAL_CONFIG_JSON_FILES
"
echo $__inputs

# Switch to Github Workspace
cd /github/workspace

# List Policies Directory Structure
ls -lta $INPUT_POLICIES_DIR

# Copy Makefile to current location
cp /Makefile Makefile

# Copy Configuration Files
if [ -z "$INPUT_ADDITIONAL_CONFIG_JSON_FILES" ]; then
    cp /config.json config.json
fi

# List final files
ls -ltr

# Run OPA Policies
make opa 

# Update PR
make comment

# Generate the Output
echo "::set-output name=result::$?"
