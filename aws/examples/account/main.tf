#
# MAINTAINER Vitaliy Natarov "vitaliy.natarov@yahoo.com"
#

terraform {
  required_version = "~> 1.0"
}

provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = [pathexpand("~/.aws/credentials")]
  profile                  = "default"

}

module "account" {
  source      = "../../modules/account"
  name        = ""
  environment = "staging"

  tags = tomap({
    "Environment" = "dev",
    "Createdby"   = "Vitaliy Natarov"
  })

}
