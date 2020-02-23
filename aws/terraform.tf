###############################################################################
# TERRAFORM REMOTE BACKEND
###############################################################################

terraform {

  required_version = ">= 0.12.0"

//  backend "s3" {
//    bucket         = "jason-morsley-dev-backend"
//    key            = "infrastructure"
//    region         = "eu-west-2"
//    dynamodb_table = "tfstatelock"
//  }
}