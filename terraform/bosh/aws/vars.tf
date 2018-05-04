variable "vpc_id" {}

variable "az1" {
  default = "eu-west-1a"
}

variable "region" {
  default = "eu-west-1"
}

variable "environment" {}

variable "concourse_ip" {
  default = "10.0.1.10"
}

variable "jumpbox_ip" {
  default = "10.0.1.11"
}
