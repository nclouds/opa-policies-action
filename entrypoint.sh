#!/bin/sh

set -e
set -o pipefail

echo "Terraform Plan to evaulate $INPUT_TFPLAN_JSON"

ls -ltr 

# Copy the JSON to policies forlder
cp $INPUT_TFPLAN_JSON policies/Infrastructure/tfplan.json

# Run Opa 
make opa

# Print the Result