module "vpc" {
  source                      = "./vpc"
  region                      = var.region
  environment                 = var.environment
  application                 = var.application
  cidr_block                  = var.vpc_cidr_block
  cidr_block_private_subnet_a = var.vpc_cidr_block_private_subnet_a
  cidr_block_private_subnet_b = var.vpc_cidr_block_private_subnet_b
  cidr_block_private_subnet_c = var.vpc_cidr_block_private_subnet_c
  cidr_block_public_subnet_a  = var.vpc_cidr_block_public_subnet_a
  cidr_block_public_subnet_b  = var.vpc_cidr_block_public_subnet_b
  cidr_block_public_subnet_c  = var.vpc_cidr_block_public_subnet_c
  logging_bucket_arn          = var.logging_bucket_arn
  tags                        = var.tags
}

module "securitygroups" {
  source                    = "./securitygroups"
  environment               = var.environment
  application               = var.application
  vpc_id                    = module.vpc.vpc_id
  public_access_cidr_blocks = var.public_access_cidr_blocks
  tags                      = var.tags
}

module "postgres" {
  source                     = "./databases/postgres"
  environment                = var.environment
  application                = var.application
  engine                     = var.db_engine
  engine_version             = var.db_engine_version
  username                   = var.postgres_dbuser
  password                   = var.postgres_dbpass
  instance_class             = var.postgres_instance_class
  subnet_ids                 = module.vpc.private_subnets
  securitygroup_ids          = module.securitygroups.postgres_securitygroup_ids
  backup_retention_period    = var.postgres_backup_retention_period
  preferred_backup_window    = var.postgres_preferred_backup_window
  maintenance_window         = var.postgres_maintenance_window
  snapshot_identifier        = var.postgres_snapshot_identifier
  skip_final_snapshot        = var.postgres_skip_final_snapshot
  key_arn                    = var.postgres_key_arn
  create_db_snapshot_restore = var.postgres_create_db_snapshot_restore
  tags                       = var.tags
}

module "documentdb" {
  source                  = "./databases/documentdb"
  environment             = var.environment
  application             = var.application
  engine                  = var.docdb_engine
  engine_version          = var.docdb_engine_version
  username                = var.docdb_dbuser
  password                = var.docdb_dbpass
  backup_retention_period = var.docdb_backup_retention_period
  preferred_backup_window = var.docdb_preferred_backup_window
  maintenance_window      = var.docdb_maintenance_window
  instance_class          = var.docdb_instance_class
  subnet_ids              = module.vpc.private_subnets
  securitygroup_ids       = module.securitygroups.docdb_securitygroup_ids
  skip_final_snapshot     = var.docdb_skip_final_snapshot
  snapshot_identifier     = var.docdb_snapshot_identifier
  key_arn                 = var.docdb_key_arn
  tags                    = var.tags
}

module "eks" {
  source                       = "./eks"
  environment                  = var.environment
  application                  = var.application
  kubernetes_version           = var.eks_kubernetes_version
  cluster_name                 = "${var.application}-eks-cluster-${var.environment}"
  cluster_security_group_ids   = module.securitygroups.eks_cluster_security_group_ids
  vpc_id                       = module.vpc.vpc_id
  public_access_cidr_blocks    = var.public_access_cidr_blocks
  subnet_ids                   = module.vpc.private_subnets
  eks_key_arn                  = var.eks_key_arn
  workers_instance_types       = [var.eks_worker_node_instance_type]
  worker_node_ami_type         = var.eks_worker_node_ami_type
  worker_security_group_ids    = module.securitygroups.eks_workers_security_group_ids
  node_group_desired_size      = var.eks_node_group_desired_size
  node_group_min_size          = var.eks_node_group_min_size
  node_group_max_size          = var.eks_node_group_max_size
  eks_alb_service_account_name = "aws-load-balancer-controller"
  region                       = var.region
  map_users                    = var.eks_map_users
  tags                         = var.tags
}

module "bastion" {
  source                      = "./ec2-instance"
  environment                 = var.environment
  application                 = var.application
  ami                         = var.ec2_ami_id
  associate_public_ip_address = true
  key_name                    = var.ec2_key_name
  security_group_ids          = module.securitygroups.ssh_public_security_group_ids
  subnet_id                   = module.vpc.public_subnet_a
  server_type                 = "bastion"
  tags                        = var.tags
}

module "privateserver" {
  source                      = "./ec2-instance"
  environment                 = var.environment
  application                 = var.application
  ami                         = var.ec2_ami_id
  associate_public_ip_address = false
  key_name                    = var.ec2_key_name
  security_group_ids          = concat(module.securitygroups.ssh_private_security_group_ids, module.securitygroups.eks_workers_security_group_ids)
  subnet_id                   = module.vpc.private_subnet_a
  server_type                 = "private"
  tags                        = var.tags
}

module "iam" {
  source         = "./iam"
  environment    = var.environment
  application    = var.application
  iam_user_names = var.iam_user_names
  ec2_instances  = [module.bastion.instance_arn, module.privateserver.instance_arn]
  tags           = var.tags
}