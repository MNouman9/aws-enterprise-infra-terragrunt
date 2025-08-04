remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    bucket  = "skolerom-${local.common_vars.environment}-tfstate"
    key     = "state/terraform.tfstate"
    region  = "eu-central-1"
    encrypt = true
  }
}

locals {
  common_vars = {
    environment                      = "dev"
    region                           = "eu-central-1"
    application                      = "skolerom"
    vpc_cidr_block                   = "172.16.0.0/21"
    vpc_cidr_block_private_subnet_a  = "172.16.0.0/24"
    vpc_cidr_block_private_subnet_b  = "172.16.1.0/24"
    vpc_cidr_block_private_subnet_c  = "172.16.2.0/24"
    vpc_cidr_block_public_subnet_a   = "172.16.4.0/24"
    vpc_cidr_block_public_subnet_b   = "172.16.5.0/24"
    vpc_cidr_block_public_subnet_c   = "172.16.6.0/24"
    db_engine                        = "postgres"
    db_engine_version                = "17.4"
    postgres_instance_class          = "db.t4g.medium"
    postgres_maintenance_window      = "sat:02:00-sat:03:00"
    postgres_backup_retention_period = 30
    postgres_preferred_backup_window = "00:00-02:00"
    postgres_skip_final_snapshot     = false
    docdb_engine                     = "docdb"
    docdb_engine_version             = "5.0.0"
    docdb_instance_class             = "db.t3.medium"
    docdb_maintenance_window         = "sat:02:00-sat:03:00"
    docdb_backup_retention_period    = 30
    docdb_preferred_backup_window    = "00:00-02:00"
    docdb_skip_final_snapshot        = false
    eks_worker_node_instance_type    = "t2.medium"
    lb_name                          = "alb-ingress"
    zone_name                        = "skolerom-dev.com"
    api_domain_name                  = "api.skolerom-dev.com"
    app_domain_name                  = "app.skolerom-dev.com"
    assets_domain_name               = "assets.skolerom-dev.com"
    search_domain_name               = "search.skolerom-dev.com"
    enable_gitops                    = true
    argocd_domain_name               = "argocd.skolerom-dev.com"
    open_domain_name                 = "open.skolerom-dev.com"
    admin_domain_name                = "admin.skolerom-dev.com"
    public_access_cidr_blocks        = ["0.0.0.0/0"]
    eks_node_group_desired_size      = 1
    eks_node_group_min_size          = 1
    eks_node_group_max_size          = 5
    eks_kubernetes_version           = "1.33"
    eks_worker_node_ami_type         = "AL2023_x86_64_STANDARD"
    eks_map_users = [
      {
        userarn  = "arn:aws:iam::714619135342:user/bayu"
        username = "bayu"
        groups   = ["system:masters"]
      },
      {
        userarn  = "arn:aws:iam::714619135342:user/monika"
        username = "monika"
        groups   = ["system:masters"]
      }
    ]
    app_custom_dns_records = [
      {
        name = ""
        type = "MX"
        ttl  = 300
        records = [
          "10 mxa.eu.mailgun.org",
          "10 mxb.eu.mailgun.org"
        ]
      },
      {
        name = ""
        type = "TXT"
        ttl  = 300
        records = [
          "v=spf1 include:eu.mailgun.org ~all"
        ]
      },
      {
        name = "email"
        type = "CNAME"
        ttl  = 300
        records = [
          "eu.mailgun.org"
        ]
      }
    ]
    sns_topic_email_list = ["bayu.yulasmono@kf.no"]
  }
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    bucket  = "skolerom-${local.common_vars.environment}-tfstate"
    key     = "state/terraform.tfstate"
    region  = "eu-central-1"
    encrypt = true
  }
}

generate "data" {
  path      = "data.tf"
  if_exists = "overwrite_terragrunt"
  disable   = get_terragrunt_dir() != "${get_repo_root()}/environment/dev/infrastructure"
  contents  = <<EOF
data "aws_eks_cluster" "cluster" {
  name = "${local.common_vars.application}-eks-cluster-${local.common_vars.environment}"
}

data "aws_eks_cluster_auth" "cluster" {
  name = "${local.common_vars.application}-eks-cluster-${local.common_vars.environment}"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

data "aws_secretsmanager_secret_version" "postgres_credentials" {
  secret_id = "${local.common_vars.application}-postgres-credentials-${local.common_vars.environment}"
}

data "aws_secretsmanager_secret_version" "documentdb_credentials" {
  secret_id = "${local.common_vars.application}-documentdb-credentials-${local.common_vars.environment}"
}
  EOF
}

generate "aws_providers" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  disable = (
    !startswith(get_terragrunt_dir(), "${get_repo_root()}/environment/dev") ||
    get_terragrunt_dir() == "${get_repo_root()}/environment/dev/app_skolerom_certificate" ||
    get_terragrunt_dir() == "${get_repo_root()}/environment/dev/app_skolerom_cloudfront" ||
    get_terragrunt_dir() == "${get_repo_root()}/environment/dev/open_skolerom_certificate" ||
    get_terragrunt_dir() == "${get_repo_root()}/environment/dev/open_skolerom_cloudfront" ||
    get_terragrunt_dir() == "${get_repo_root()}/environment/dev/assets_skolerom_certificate" ||
    get_terragrunt_dir() == "${get_repo_root()}/environment/dev/assets_skolerom_cloudfront" ||
    get_terragrunt_dir() == "${get_repo_root()}/environment/dev/admin_skolerom_certificate" ||
    get_terragrunt_dir() == "${get_repo_root()}/environment/dev/api_skolerom_certificate" ||
    get_terragrunt_dir() == "${get_repo_root()}/environment/dev/search_skolerom_certificate" ||
    get_terragrunt_dir() == "${get_repo_root()}/environment/dev/argocd_certificate"
  )
  contents = <<EOF
provider "aws" {
  region = "${local.common_vars.region}"
}
EOF
}

generate "providers" {
  path      = "eks_providers.tf"
  if_exists = "overwrite_terragrunt"
  disable   = get_terragrunt_dir() != "${get_repo_root()}/environment/dev/infrastructure"
  contents  = <<EOF
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}
EOF
}

generate "versions" {
  path      = "versions.tf"
  if_exists = "overwrite_terragrunt"
  disable = (
    get_terragrunt_dir() == "${get_repo_root()}/environment/dev/app_skolerom_cloudfront" ||
    get_terragrunt_dir() == "${get_repo_root()}/environment/dev/open_skolerom_cloudfront"
  )
  contents = <<EOF
terraform {
  required_version = "> 0.14"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.99.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.16.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.37.1"
    }
  }
}
EOF
}

generate "ssh_keys" {
  path      = "ssh_keys.tf"
  if_exists = "overwrite_terragrunt"
  disable   = get_terragrunt_dir() != "${get_repo_root()}/environment/dev"
  contents  = <<EOF
resource "aws_key_pair" "default" {
  key_name   = "${local.common_vars.application}-${local.common_vars.environment}-default-ssh-key"
  public_key = ""
}
  EOF
}

generate "locals" {
  path      = "locals.tf"
  if_exists = "overwrite_terragrunt"
  disable   = get_terragrunt_dir() != "${get_repo_root()}/environment/dev"
  contents  = <<EOF
locals {
  postgres_credentials = jsondecode(
    data.aws_secretsmanager_secret_version.postgres_credentials.secret_string
  )

  documentdb_credentials = jsondecode(
    data.aws_secretsmanager_secret_version.documentdb_credentials.secret_string
  )

  tags = {
    Environment = var.environment
    Application = var.application
    ManagedBy   = "Terraform"
    ConfiguredBy = "Terragrunt"
  }
}
EOF
}