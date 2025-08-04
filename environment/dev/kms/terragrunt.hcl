terraform {
  source = "../../../modules//kms"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("root.hcl")).locals.common_vars
}

# generate "kms-providers" {
#   path      = "kms-providers.tf"
#   if_exists = "overwrite_terragrunt"
#   contents  = <<EOF
# provider "aws" {
#   region = "${local.common_vars.region}"
# }
# EOF
# }

inputs = {
  environment = local.common_vars.environment
  application = local.common_vars.application
}