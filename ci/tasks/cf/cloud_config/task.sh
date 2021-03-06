#!/bin/bash

set -euo pipefail

jq '.modules[0].outputs | with_entries(.value = .value.value)' < vpc-tfstate-s3/tfstate.json > vpc-vars.json
jq '.modules[0].outputs | with_entries(.value = .value.value)' < concourse-tfstate-s3/tfstate.json > concourse-vars.json
jq '.modules[0].outputs | with_entries(.value = .value.value)' < "cf-tfstate-s3/${ENVIRONMENT}.tfstate" > cf-vars.json
jq '.modules[0].outputs | with_entries(.value = .value.value)' < "prometheus-tfstate-s3/${ENVIRONMENT}.tfstate" > prometheus-vars.json

bosh_admin_password=$(bosh int bosh-vars-s3/bosh-variables.yml --path /admin_password)
bosh int bosh-vars-s3/bosh-variables.yml --path /default_ca/ca > bosh_ca.pem
bosh_ip=$(bosh int --path '/cloud_provider/ssh_tunnel/host' bosh-manifest-s3/bosh.yml)

export BOSH_CLIENT=admin
export BOSH_CLIENT_SECRET="${bosh_admin_password}"
export BOSH_ENVIRONMENT="https://${bosh_ip}:25555"
export BOSH_CA_CERT=bosh_ca.pem

bosh update-cloud-config -n \
  paas-bootstrap-git/cloud-config/cf/cloud-config.yml \
  -o paas-bootstrap-git/operations/cloud-config/router-extensions.yml \
  -o paas-bootstrap-git/operations/cloud-config/cf-scheduler-extensions.yml \
  -o paas-bootstrap-git/operations/cloud-config/cf-s3-blobstore.yml \
  -o paas-bootstrap-git/operations/cloud-config/cf-rds-sec-group.yml \
  -o paas-bootstrap-git/operations/cloud-config/prometheus.yml \
  -v az1="$(jq -r .az1 < vpc-vars.json)" \
  -v az2="$(jq -r .az2 < vpc-vars.json)" \
  -v az3="$(jq -r .az3 < vpc-vars.json)" \
  -v private_subnet_az1_gateway="$(jq -r '.cf_internal_subnet_az1_cidr' < cf-vars.json | sed 's#0/24#1#')" \
  -v private_subnet_az2_gateway="$(jq -r '.cf_internal_subnet_az2_cidr' < cf-vars.json | sed 's#0/24#1#')" \
  -v private_subnet_az3_gateway="$(jq -r '.cf_internal_subnet_az3_cidr' < cf-vars.json | sed 's#0/24#1#')" \
  -v reserved_az1_cidr="$(jq -r '.cf_internal_subnet_az1_cidr' < cf-vars.json  | sed 's#0/24#1/30#')" \
  -v reserved_az2_cidr="$(jq -r '.cf_internal_subnet_az2_cidr' < cf-vars.json  | sed 's#0/24#1/30#')" \
  -v reserved_az3_cidr="$(jq -r '.cf_internal_subnet_az3_cidr' < cf-vars.json  | sed 's#0/24#1/30#')" \
  -v private_dns_nameserver="$(jq -r '.vpc_dns_nameserver' < vpc-vars.json)" \
  -v internal_security_group="$(jq -r '.cf_internal_security_group_id' < cf-vars.json)" \
  -v private_subnet_az1_id="$(jq -r '.cf_internal_subnet_az1_id' < cf-vars.json)" \
  -v private_subnet_az2_id="$(jq -r '.cf_internal_subnet_az2_id' < cf-vars.json)" \
  -v private_subnet_az3_id="$(jq -r '.cf_internal_subnet_az3_id' < cf-vars.json)" \
  -v private_subnet_az1_cidr="$(jq -r '.cf_internal_subnet_az1_cidr' < cf-vars.json)" \
  -v private_subnet_az2_cidr="$(jq -r '.cf_internal_subnet_az2_cidr' < cf-vars.json)" \
  -v private_subnet_az3_cidr="$(jq -r '.cf_internal_subnet_az3_cidr' < cf-vars.json)" \
  -v cf-router-target-group-name="$(jq -r '.cf_router_target_group_name' < cf-vars.json)" \
  -v cf-router-lb-internal-security-group-id="$(jq -r '.cf_router_lb_internal_security_group_id' < cf-vars.json)" \
  -v cf-internal-security-group-id="$(jq -r '.cf_internal_security_group_id' < cf-vars.json)" \
  -v cf-ssh-internal="$(jq -r '.cf_ssh_internal' < cf-vars.json)" \
  -v cf-ssh-lb="$(jq -r '.cf_ssh_lb' < cf-vars.json)" \
  -v cf_s3_iam_instance_profile="$(jq -r '.cf_s3_iam_instance_profile' < cf-vars.json)" \
  -v cf-rds-client-security-group="$(jq -r '.cf_rds_client_security_group_id' < cf-vars.json)" \
  -v prometheus_subnet_az1_cidr="$(jq -r .prometheus_subnet_az1_cidr < prometheus-vars.json)" \
  -v prometheus_subnet_az1_id="$(jq -r .prometheus_subnet_az1_id < prometheus-vars.json)" \
  -v prometheus_security_group="$(jq -r .prometheus_security_group_id < prometheus-vars.json)" \
  -v prometheus_subnet_az1_gateway="$(jq -r .prometheus_subnet_az1_cidr < prometheus-vars.json | sed 's#0/24#1#')" \
  -v grafana_target_group_name="$(jq -r .grafana_target_group_name < prometheus-vars.json)" \
  -v prometheus_target_group_name="$(jq -r .prometheus_target_group_name < prometheus-vars.json)" \
  -v alertmanager_target_group_name="$(jq -r .alertmanager_target_group_name < prometheus-vars.json)" 

bosh cloud-config > cf-manifests/cloud-config.yml
