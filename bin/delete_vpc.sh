#!/bin/bash

set -euo pipefail

: $ENVIRONMENT
: $VAR_FILE
: $VPC_STATE_FILE

TERRAFORM_DIR=terraform/aws

aws s3 cp "s3://${ENVIRONMENT}-states/vpc/tfstate.json" "${VPC_STATE_FILE}" ||
  {
    echo "Remote VPC Terraform state does not exist. Assuming is has already been deleted";
    exit 0
  }

bin/wipe_s3_bucket.sh

terraform destroy -auto-approve \
  -var "environment=$ENVIRONMENT" \
  -var-file="$VAR_FILE" \
  -state="$VPC_STATE_FILE" \
  "$TERRAFORM_DIR"

rm "${VPC_STATE_FILE}" || true
rm "${VAR_FILE}" || true
