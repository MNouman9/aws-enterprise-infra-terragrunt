terraform {
  source = "${get_repo_root()}/modules/waf"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("root.hcl")).locals.common_vars
}

dependency "logging" {
  config_path = "${get_repo_root()}/environment/dev/logging"

  mock_outputs = {
    waf_logs_kinesis_firehose_delivery_stream_arn = "arn:aws:kinesis:eu-central-1:111122223333:stream/mock-waf_logs_kinesis_firehose_delivery_stream_arn"
  }
}

inputs = {
  environment                          = local.common_vars.environment
  application                          = local.common_vars.application
  kinesis_firehose_delivery_stream_arn = dependency.logging.outputs.waf_logs_kinesis_firehose_delivery_stream_arn
  tags = {
    Environment = local.common_vars.environment
    Application = local.common_vars.application
    ManagedBy   = "Terragrunt"
  }

  managed_rule_groups = [
    {
      name        = "AWSManagedRulesCommonRuleSet"
      vendor_name = "AWS"
    }
  ]
}