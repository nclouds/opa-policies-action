#!/bin/sh

set -e
set -o pipefail

# Print the Input Variables
__inputs="
    Policies Directory: $INPUT_POLICIES_DIR
    Path to Terraform Plan: $INPUT_TFPLAN_JSON_PATH
    Additonal Data or Configuration Files: $INPUT_DATA_JSON_PATHS
"
# Switch to Github Workspace
cd /github/workspace

# List files inside workspace
ls -ltr
cat tfplan.json

# Generate the Output
echo "::set-output name=result::$?"
