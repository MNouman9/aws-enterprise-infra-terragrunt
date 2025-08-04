terraform {
  source = "${get_repo_root()}/modules/codestarconnecitons-connection"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("root.hcl")).locals.common_vars
}

inputs = {
  environment = local.common_vars.environment
  application = local.common_vars.application
  tags = {
    Environment = local.common_vars.environment
    Application = local.common_vars.application
    ManagedBy   = "Terragrunt"
  }
}