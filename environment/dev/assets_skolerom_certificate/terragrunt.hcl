terraform {
  source = "../../../modules//acm"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "route53" {
  config_path = "../route53"

  mock_outputs = {
    route53_zone_id = "mock-route53-output-route53_zone_id"
  }
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("root.hcl")).locals.common_vars
}

# generate "app-cert-providers" {
#   path      = "providers.tf"
#   if_exists = "overwrite_terragrunt"
#   contents  = <<EOF
# provider "aws" {
#   region = "us-east-1"
# }
# EOF
# }

inputs = {
  environment     = local.common_vars.environment
  application     = local.common_vars.application
  region          = "us-east-1"
  domain_name     = local.common_vars.app_domain_name
  route53_zone_id = dependency.route53.outputs.route53_zone_id
}