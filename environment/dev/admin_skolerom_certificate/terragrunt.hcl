terraform {
<<<<<<< Updated upstream
  source = "../../../modules//acm"
=======
  source = "${get_repo_root()}/modules/acm"
>>>>>>> Stashed changes
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

<<<<<<< Updated upstream
dependency "route53" {
  config_path = "../route53"
=======
locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("root.hcl")).locals.common_vars
}

dependency "route53" {
  config_path = "${get_repo_root()}/environment/dev/route53"
>>>>>>> Stashed changes

  mock_outputs = {
    route53_zone_id = "mock-route53-output-route53_zone_id"
  }
}

<<<<<<< Updated upstream
locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("root.hcl")).locals.common_vars
}

# generate "admin-cert-providers" {
#   path      = "${local.common_vars.region}-providers.tf"
#   if_exists = "overwrite_terragrunt"
#   contents  = <<EOF
# provider "aws" {
#   region = "${local.common_vars.region}"
# }
# EOF
# }

=======
>>>>>>> Stashed changes
inputs = {
  environment     = local.common_vars.environment
  application     = local.common_vars.application
  region          = local.common_vars.region
  domain_name     = local.common_vars.admin_domain_name
  route53_zone_id = dependency.route53.outputs.route53_zone_id
}