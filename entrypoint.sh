#!/bin/sh

set -e
set -o pipefail

# Print the Input Variables
__inputs="
    Policies Directory: $INPUT_POLICIES_DIR
    Path to Terraform Plan: $INPUT_TFPLAN_JSON
    Additonal Data or Configuration Files: $INPUT_DATA_FILES
"
# Switch to Github Workspace
cd /github/workspace

# List files inside workspace
ls -lta policies

# Copy Makefile to current location
cp /Makefile Makefile

# Run OPA Policies
make opa 

# Generate the Output
echo "::set-output name=result::$?"
