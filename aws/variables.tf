###############################################################################
# VARIABLES
###############################################################################

variable "region" {
  default = "eu-west-2" # London
}

variable "access_key" {}

variable "secret_key" {}

variable "key_name" {
  default = "jason-morsley-dev-concourse"
}

variable "public_keys_bucket" {
  default = "jason-morsley-dev-concourse-public-keys"
}

variable "private_keys_bucket" {
  default = "jason-morsley-dev-concourse-private-keys"
}