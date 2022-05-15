#!/bin/sh

set -e
set -o pipefail

echo "Terraform Plan to evaulate $INPUT_TFPLAN_JSON"


# Copy the JSON to policies forlder
cp -R /policies .
cp /Makefile .

ls -ltr
cp $INPUT_TFPLAN_JSON policies/Infrastructure/tfplan.json

ls -ltr

# Run Opa 
make opa

# Print the Result