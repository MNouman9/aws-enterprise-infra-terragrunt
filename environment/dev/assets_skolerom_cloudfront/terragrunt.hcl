terraform {
  source = "../../../modules//cloudfront"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}


dependency "logging" {
  config_path = "../logging"

  mock_outputs = {
    bucket_id          = "mock-logging-bucket-id"
    bucket_domain_name = "mock-logging-bucket-domain"
  }
}

dependency "assets_skolerom_certificate" {
  config_path = "../assets_skolerom_certificate"

  mock_outputs = {
    certificate_arn = "arn:aws:acm:eu-central-1:111122223333:key/mock-acm-output-certificate_arn"
  }
}

# dependency "route53" {
#   config_path = "../route53"

#   mock_outputs = {
#     route53_zone_id = "mock-route53-output-route53_zone_id"
#   }
# }

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("root.hcl")).locals.common_vars
}

# generate "app-cloudfront-providers" {
#   path      = "providers.tf"
#   if_exists = "overwrite_terragrunt"
#   contents  = <<EOF
# provider "aws" {
#   alias  = "us_east_1"
#   region = "us-east-1"
# }
# EOF
# }

inputs = {
  environment     = local.common_vars.environment
  application     = local.common_vars.application
  dist_name       = "assets"
  certificate_arn = dependency.assets_skolerom_certificate.outputs.certificate_arn
  # route53_zone_id            = dependency.route53.outputs.route53_zone_id
  domain_name                = local.common_vars.assets_domain_name
  logging_bucket_id          = dependency.logging.outputs.bucket_id
  logging_bucket_domain_name = dependency.logging.outputs.bucket_domain_name
}
