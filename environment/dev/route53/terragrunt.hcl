terraform {
  source = "../../../modules//route53"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

# dependency "app_skolerom_cloudfront" {
#   config_path = "../app_skolerom_cloudfront"

#   mock_outputs = {
#     cloudfront_distribution_domain_name    = "mock-app-cloudfront_distribution_domain_name"
#     cloudfront_distribution_hosted_zone_id = "mock-app-cloudfront_distribution_hosted_zone_id"
#   }
# }

# dependency "open_skolerom_cloudfront" {
#   config_path = "../open_skolerom_cloudfront"

#   mock_outputs = {
#     cloudfront_distribution_domain_name    = "mock-open-cloudfront_distribution_domain_name"
#     cloudfront_distribution_hosted_zone_id = "mock-open-cloudfront_distribution_hosted_zone_id"
#   }
# }

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("root.hcl")).locals.common_vars
}

# generate "route53-providers" {
#   path      = "providers.tf"
#   if_exists = "overwrite_terragrunt"
#   contents  = <<EOF
# provider "aws" {
#   region = "${local.common_vars.region}"
# }
# EOF
# }

inputs = {
  zone_name = local.common_vars.zone_name
  comment   = "Development hosted zone"
  tags = {
    Environment = local.common_vars.environment
    Application = local.common_vars.application
  }
  force_destroy = true

  # records = [
  #   {
  #     name    = "api"
  #     type    = "A"
  #     ttl     = 300
  #     records = ["1.2.3.4"]
  #   },
  #   {
  #     name    = ""
  #     type    = "MX"
  #     ttl     = 3600
  #     records = ["10 mail.skolerom-dev.com"]
  #   }
  # ]

  records = concat(
    [
      {
        name    = ""
        type    = "A"
        ttl     = 300
        records = ["57.129.65.93"]
      } #,
      # {
      #   name = "app"
      #   type = "A"
      #   alias = {
      #     name                   = module.app_skolerom_cloudfront.cloudfront_distribution_domain_name
      #     zone_id                = module.app_skolerom_cloudfront.cloudfront_distribution_hosted_zone_id
      #     evaluate_target_health = false
      #   }
      # },
      # {
      #   name = "open"
      #   type = "A"
      #   alias = {
      #     name                   = module.open_skolerom_cloudfront.cloudfront_distribution_domain_name
      #     zone_id                = module.open_skolerom_cloudfront.cloudfront_distribution_hosted_zone_id
      #     evaluate_target_health = false
      #   }
      # }
    ] #,
    # local.common_vars.app_custom_dns_records
  )
}