terraform {
  source = "../../../modules//infrastructure"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "kms" {
  config_path = "../kms"
  mock_outputs = {
    postgres_key_arn = "arn:aws:kms:eu-central-1:111122223333:key/mock-postgres-key"
    docdb_key_arn    = "arn:aws:kms:eu-central-1:111122223333:key/mock-docdb-key"
    eks_key_arn      = "arn:aws:kms:eu-central-1:111122223333:key/mock-eks-key"
  }
}

dependency "logging" {
  config_path = "../logging"

  mock_outputs = {
    bucket_arn = "arn:aws:s3:::mock-logging-output-bucket_arn"
  }
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("root.hcl")).locals.common_vars
}

# generate "infra-providers" {
#   path      = "infra-providers.tf"
#   if_exists = "overwrite_terragrunt"
#   contents  = <<EOF
# provider "aws" {
#   region = "${local.common_vars.region}"
# }
# EOF
# }

inputs = {
  region                              = local.common_vars.region
  environment                         = local.common_vars.environment
  application                         = local.common_vars.application
  vpc_cidr_block                      = local.common_vars.vpc_cidr_block
  vpc_cidr_block_private_subnet_a     = local.common_vars.vpc_cidr_block_private_subnet_a
  vpc_cidr_block_private_subnet_b     = local.common_vars.vpc_cidr_block_private_subnet_b
  vpc_cidr_block_private_subnet_c     = local.common_vars.vpc_cidr_block_private_subnet_c
  vpc_cidr_block_public_subnet_a      = local.common_vars.vpc_cidr_block_public_subnet_a
  vpc_cidr_block_public_subnet_b      = local.common_vars.vpc_cidr_block_public_subnet_b
  vpc_cidr_block_public_subnet_c      = local.common_vars.vpc_cidr_block_public_subnet_c
  db_engine                           = local.common_vars.db_engine
  db_engine_version                   = local.common_vars.db_engine_version
  postgres_instance_class             = local.common_vars.postgres_instance_class
  postgres_maintenance_window         = local.common_vars.postgres_maintenance_window
  postgres_backup_retention_period    = local.common_vars.postgres_backup_retention_period
  postgres_preferred_backup_window    = local.common_vars.postgres_preferred_backup_window
  postgres_snapshot_identifier        = local.common_vars.postgres_snapshot_identifier
  postgres_skip_final_snapshot        = local.common_vars.postgres_skip_final_snapshot
  postgres_key_arn                    = dependency.kms.outputs.postgres_key_arn
  postgres_create_db_snapshot_restore = local.common_vars.postgres_create_db_snapshot_restore
  docdb_engine                        = local.common_vars.docdb_engine
  docdb_engine_version                = local.common_vars.docdb_engine_version
  docdb_backup_retention_period       = local.common_vars.docdb_backup_retention_period
  docdb_preferred_backup_window       = local.common_vars.docdb_preferred_backup_window
  docdb_instance_class                = local.common_vars.docdb_instance_class
  docdb_maintenance_window            = local.common_vars.docdb_maintenance_window
  docdb_snapshot_identifier           = local.common_vars.docdb_snapshot_identifier
  docdb_skip_final_snapshot           = local.common_vars.docdb_skip_final_snapshot
  docdb_key_arn                       = dependency.kms.outputs.docdb_key_arn
  eks_worker_node_instance_type       = local.common_vars.eks_worker_node_instance_type
  eks_node_group_desired_size         = local.common_vars.eks_node_group_desired_size
  eks_node_group_min_size             = local.common_vars.eks_node_group_min_size
  eks_node_group_max_size             = local.common_vars.eks_node_group_max_size
  eks_kubernetes_version              = local.common_vars.eks_kubernetes_version
  eks_key_arn                         = dependency.kms.outputs.eks_key_arn
  eks_map_users                       = local.common_vars.eks_map_users
  ec2_ami_id                          = "ami-0ff740d97eb730dec"
  logging_bucket_arn                  = dependency.logging.outputs.bucket_arn
  public_access_cidr_blocks           = local.common_vars.public_access_cidr_blocks
  iam_user_names                      = local.common_vars.iam_user_names
  enable_gitops                       = local.common_vars.enable_gitops
}

generate "data-internal" {
  path      = "data-internal.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
data "aws_lb" "shared-alb" {
  name = "${local.common_vars.lb_name}"
}

output "alb_dns_name" {
  value = data.aws_lb.shared-alb.dns_name
}
EOF
}