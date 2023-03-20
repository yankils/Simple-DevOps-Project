# Provider block
terraform {
  required_version = ">= 0.13.0, < 0.15"

  required_providers {
    aws = ">= 2.68, < 4.0"
  }
  backend "s3" {
    key            = "cirrus-ta-iac/deployment-roles/eu-north-1/terraform.tfstate"
    bucket         = "cirrus-dev-eu-north-1-terraform"
    dynamodb_table = "cirrus-dev-eu-north-1-state-file-lock"
    region         = "eu-north-1"
  }
}

provider "aws" {
  region = "eu-north-1"
}

# Locals 
locals {
  environment = "dev"

  tags = {
    terraform   = "True"
    environment = local.environment
  }
}

# Data source to get account id and region 
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}


#lookups

data "aws_kms_key" "key_platform_shared_id" {
  key_id = "a5faed77-005a-4c70-97e7-2df40e7341b1"
}

data "aws_kms_key" "tf_backend_kms_key" {
  key_id = "13c13360-0ea4-4d5c-8376-1d086d35c5ee"
}

data "aws_dynamodb_table" "tf_backend_lock_table" {
  name = "cirrus-dev-eu-north-1-state-file-lock"
}

data "aws_s3_bucket" "tf_backend_s3_bucket" {
  bucket = "cirrus-dev-eu-north-1-terraform"
}

module "sdlf_foundation_deployment_role" {
  source = "git::https://github.com/TeliaSoneraNorge/cirrus-ta-aws-iac-modules.git//modules/deployment-role/sdlf-foundation?ref=v0.5.0"
  # source      = "../../../../cirrus-ta-aws-iac-modules/modules/deployment-role/sdlf-foundation"
  name_prefix = "cirrus"
  environment = local.environment

  key_platform_shared_id = data.aws_kms_key.key_platform_shared_id.arn
  key_tf_backend_id      = data.aws_kms_key.tf_backend_kms_key.arn
  tf_lock_table_name     = data.aws_dynamodb_table.tf_backend_lock_table.name
  tf_state_bucket_name   = data.aws_s3_bucket.tf_backend_s3_bucket.id

  tags = local.tags
}

