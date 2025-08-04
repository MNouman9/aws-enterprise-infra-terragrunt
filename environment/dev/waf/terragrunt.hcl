terraform {
  source = "../../../modules//waf"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "logging" {
  config_path = "../logging"

  mock_outputs = {
    waf_logs_kinesis_firehose_delivery_stream_arn = "arn:aws:kms:eu-central-1:111122223333:key/mock-waf_logs_kinesis_firehose_delivery_stream_arn"
  }
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("root.hcl")).locals.common_vars
}

# generate "waf-providers" {
#   path      = "providers.tf"
#   if_exists = "overwrite_terragrunt"
#   contents  = <<EOF
# provider "aws" {
#   region = "us-east-1"
# }
# EOF
# }

inputs = {
  environment                          = local.common_vars.environment
  application                          = local.common_vars.application
  kinesis_firehose_delivery_stream_arn = dependency.logging.outputs.waf_logs_kinesis_firehose_delivery_stream_arn
  managed_rule_groups = [
    {
      name        = "AWSManagedRulesCommonRuleSet"
      vendor_name = "AWS"

      rule_action_overrides = [
        {
          name          = "SizeRestrictions_BODY"
          action_to_use = "COUNT"
        }
      ]
    }
  ]
}