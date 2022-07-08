#!/bin/sh

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
    cp /config.json $INPUT_POLICIES_DIR/config.json
fi

# List final files
ls -ltr

# Run OPA Policies
make opa

if [ "$?" -eq "0" ]
then
  echo "OPA Tests SUCCESS!!, commenting on Pull Request"
  OPA_OUTPUT=0
  make comment
else
  echo "OPA Tests FAILED!!, commenting on Pull Request"
  OPA_OUTPUT=1
  make comment
fi

# Generate the Output
echo "::set-output name=result::$OPA_OUTPUT"

# Fail the action of OPA is not success
if [ "$OPA_OUTPUT" -ne "0" ]
then 
    exit 1
fi
