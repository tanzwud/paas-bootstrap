#!/bin/bash

set -euo pipefail

: $DOMAIN

ADMIN_PASSWORD="$(bosh int --path cf-vars-s3/cf-variables.yml --path /cf_admin_password)"

cat $CATS_CONFIG_FILE | jq "
.api = \"api.system.${DOMAIN}\" | 
.apps_domain = \"apps.${DOMAIN}\" |
.admin_user = \"admin\" |
.admin_password = \"${ADMIN_PASSWORD}\"
" > cats/cats_config.json