variable "vpc_id" {}

variable "az1" {
  default = "eu-west-1a"
}

variable "az2" {
  default = "eu-west-1b"
}

variable "az3" {
  default = "eu-west-1c"
}

variable "region" {
  default = "eu-west-1"
}

variable "environment" {}

variable "ingress_whitelist" {
  "type" = "list"
}

variable "parent_dns_zone" {}

variable "private_dns_zone" {}

variable "bosh_security_group_id" {}
variable "jumpbox_security_group_id" {}

variable "concourse_security_group_id" {}
variable "s3_kms_key_id" {}
variable "s3_kms_key_arn" {}
variable "state_bucket_id" {}

variable "nat_az1_id" {}
variable "nat_az2_id" {}
variable "nat_az3_id" {}

variable "concourse_public_ip" {
  description = "Concourse public IP"
}

variable "s3_prefix" {}
