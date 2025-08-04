terraform {
  source = "../../../modules//kubernetes-ingress"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "infrastructure" {
  config_path = "../infrastructure"

  mock_outputs = {
    alb_dns_name = "mock-infrastructure-output-alb_dns_name"
  }
}

dependency "admin_skolerom_certificate" {
  config_path = "../admin_skolerom_certificate"

  mock_outputs = {
    certificate_arn = "arn:aws:acm:eu-central-1:111122223333:key/mock-acm-output-certificate_arn"
  }
}

dependency "waf" {
  config_path = "../waf"

  mock_outputs = {
    waf_acl_arn = "arn:aws:acm:eu-central-1:111122223333:key/mock-waf-output-waf_acl_arn"
  }
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

# generate "ingress-providers" {
#   path      = "ingress-providers.tf"
#   if_exists = "overwrite_terragrunt"
#   contents  = <<EOF
# provider "aws" {
#   region = "${local.common_vars.region}"
# }
# EOF
# }

inputs = {
  environment        = local.common_vars.environment
  namespace          = "${local.common_vars.environment}-${local.common_vars.application}-admin"
  lb_name            = local.common_vars.lb_name
  record             = dependency.infrastructure.outputs.alb_dns_name
  service_name       = "${local.common_vars.environment}-${local.common_vars.application}-admin-svc"
  ingress_group_name = "${local.common_vars.application}-${local.common_vars.environment}-ingress-group"
  certificate_arn    = dependency.admin_skolerom_certificate.outputs.certificate_arn
  application        = local.common_vars.application
  app_name           = "admin"
  waf_acl_arn        = dependency.waf.outputs.waf_acl_arn
  route53_zone_id    = dependency.route53.outputs.route53_zone_id
  url                = local.common_vars.admin_domain_name
}