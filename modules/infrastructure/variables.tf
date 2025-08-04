# Generic variables
variable "environment" {
  type        = string
  description = "Name of the Environment"
}

variable "region" {
  description = "AWS region for all resources"
}
variable "application" {
  description = "The name of the application."
}

variable "eks_kubernetes_version" {
  description = "Kubernetes version of eks cluster and nodes."
  type        = string
}

variable "eks_map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
}
variable "eks_worker_node_instance_type" {
  description = "Instance type of the worker nodes."
  type        = string
}
variable "eks_worker_node_ami_type" {
  description = "AMI type of the worker nodes."
  type        = string
}
variable "eks_node_group_desired_size" {
  description = "Desired number of worker nodes for eks cluster"
  type        = number
}
variable "eks_node_group_min_size" {
  description = "Min number of worker nodes for eks cluster"
  type        = number
}
variable "eks_node_group_max_size" {
  description = "Max number of worker nodes for eks cluster"
  type        = number
}
variable "logging_bucket_arn" {
  type        = string
  description = "Arn of the bucket used for logging."
}

variable "public_access_cidr_blocks" {
  description = "List of cidr blocks for public access to the environment."
  type        = list(string)
}

# Subnet variables
variable "vpc_cidr_block" {
  description = "cidr block for vpc"
}
variable "vpc_cidr_block_private_subnet_a" {
  description = "cidr block for private subnet a"
}
variable "vpc_cidr_block_private_subnet_b" {
  description = "cidr block for private subnet b"
}
variable "vpc_cidr_block_private_subnet_c" {
  description = "cidr block for private subnet c"
}
variable "vpc_cidr_block_public_subnet_a" {
  description = "cidr block for public subnet a"
}
variable "vpc_cidr_block_public_subnet_b" {
  description = "cidr block for public subnet b"
}
variable "vpc_cidr_block_public_subnet_c" {
  description = "cidr block for public subnet c"
}

# Postgres variables
variable "db_engine" {
  type        = string
  description = "Database engine type (e.g. postgres)"
}
variable "db_engine_version" {
  type        = string
  description = "Database Engine Version"
}
variable "postgres_dbuser" {
  description = "Username for the master user in the Postgres DB."
  sensitive   = true
}
variable "postgres_dbpass" {
  description = "Password for the master user in the Postgres DB."
  sensitive   = true
}
variable "postgres_maintenance_window" {
  type        = string
  description = "The daily time range during which maintenance are applied."
}
variable "postgres_snapshot_identifier" {
  type        = string
  description = "Specifies whether or not to create the database from a snapshot."
  default     = null
}
variable "postgres_instance_class" {
  description = "The instance type of the RDS instance"
}
variable "postgres_backup_retention_period" {
  description = "Number of days to retain backups for."
}
variable "postgres_preferred_backup_window" {
  description = "The daily time range during which automated backups are created."
}

variable "postgres_skip_final_snapshot" {
  default     = false
  description = "If `true` no final snapshot will be taken on termination"
  type        = bool
}
variable "postgres_key_arn" {
  type        = string
  description = "Kms key used for DocumentDB secrets."
}
variable "postgres_create_db_snapshot_restore" {
  default     = false
  description = "If `true` a snapshot will be created and restored on instance startup."
  type        = bool
}
# DocumentDB variables
variable "docdb_engine" {
  type        = string
  description = "Database engine type (e.g. docdb)"
}
variable "docdb_engine_version" {
  type        = string
  description = "Database Engine Version"
}
variable "docdb_dbuser" {
  description = "Username for the master user in the DocumentDB."
  sensitive   = true
}
variable "docdb_dbpass" {
  description = "Password for the master user in the DocumentDB."
  sensitive   = true
}
variable "docdb_maintenance_window" {
  type        = string
  description = "The daily time range during which maintenance are applied."
}
variable "docdb_snapshot_identifier" {
  type        = string
  description = "Specifies whether or not to create the database from a snapshot."
  default     = null
}
variable "docdb_backup_retention_period" {
  description = "Number of days to retain backups for."
}
variable "docdb_preferred_backup_window" {
  description = "The daily time range during which automated backups are created."
}
variable "docdb_instance_class" {
  description = "The instance type of the RDS instance"
}
variable "docdb_skip_final_snapshot" {
  default     = false
  description = "If `true` no final snapshot will be taken on termination"
  type        = bool
}
variable "docdb_key_arn" {
  type        = string
  description = "Kms key used for DocumentDB secrets."
}

# EKS variables
variable "eks_key_arn" {
  type        = string
  description = "Kms key used for eks secrets."
}

# ec2 variables
variable "ec2_ami_id" {
  type        = string
  description = "Ami id for ec2 instances."
}

variable "ec2_key_name" {
  type        = string
  description = "Name of the ssh key for ec2 instandce."
}
variable "iam_user_names" {
  description = "IAM user names."
  type        = list(string)
}


#ArgoCD
variable "enable_gitops" {
  description = "Enable or disable the GitOps module"
  type        = bool
  default     = false
}

# Addons Git
variable "gitops_addons_org" {
  description = "Git repository org/user contains for addons"
  type        = string
  default     = "https://github.com/aws-samples"

}
variable "gitops_addons_repo" {
  description = "Git repository contains for addons"
  type        = string
  default     = "eks-blueprints-add-ons"
}
variable "gitops_addons_revision" {
  description = "Git repository revision/branch/ref for addons"
  type        = string
  default     = "main"
}
variable "gitops_addons_basepath" {
  description = "Git repository base path for addons"
  type        = string
  default     = "argocd/"
}
variable "gitops_addons_path" {
  description = "Git repository path for addons"
  type        = string
  default     = "bootstrap/control-plane/addons"
}

# Workloads Git
variable "gitops_workload_org" {
  description = "Git repository org/user contains for workload"
  type        = string
  default     = "https://github.com/aws-ia"
}
variable "gitops_workload_repo" {
  description = "Git repository contains for workload"
  type        = string
  default     = "terraform-aws-eks-blueprints"
}
variable "gitops_workload_revision" {
  description = "Git repository revision/branch/ref for workload"
  type        = string
  default     = "main"
}
variable "gitops_workload_basepath" {
  description = "Git repository base path for workload"
  type        = string
  default     = "patterns/gitops/"
}
variable "gitops_workload_path" {
  description = "Git repository path for workload"
  type        = string
  default     = "getting-started-argocd/k8s"
}
variable "addons" {
  description = "Kubernetes addons"
  type        = any
  default = {
    enable_aws_load_balancer_controller = true
    enable_metrics_server               = true
  }
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resource."
  default     = {}
}