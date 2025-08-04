terraform {
  source = "../../../modules//data-bucket"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "logging" {
  config_path = "../logging"

  mock_outputs = {
    bucket_id = "mock-logging-output-bucket_id"
  }
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("root.hcl")).locals.common_vars
}

# generate "data-bucket-providers" {
#   path      = "bucket-providers.tf"
#   if_exists = "overwrite_terragrunt"
#   contents  = <<EOF
# provider "aws" {
#   region = "${local.common_vars.region}"
# }
# EOF
# }

inputs = {
  environment       = local.common_vars.environment
  application       = local.common_vars.application
  logging_bucket_id = dependency.logging.outputs.bucket_id
}