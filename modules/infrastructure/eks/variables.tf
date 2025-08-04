variable "create" {
  description = "Controls if EKS resources should be created (affects nearly all resources)"
  type        = bool
  default     = true
}

variable "environment" {
  type        = string
  description = "Name of the Environment"
}

variable "application" {
  type        = string
  description = "The name of the application."
}

variable "cluster_name" {
  type        = string
  description = "Name of the eks cluster."
}

variable "cluster_security_group_ids" {
  type        = list(string)
  description = "Security groups for the eks cluster."
}

variable "kubernetes_version" {
  description = "Kubernetes version of eks cluster and nodes."
  type        = string
}
variable "vpc_id" {
  type        = string
  description = "Vpc id for eks cluster and nodes."
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet ids for eks cluser and nodes."
}

variable "eks_key_arn" {
  type        = string
  description = "Arn of the eks encryption key."
}

variable "workers_instance_types" {
  type        = list(string)
  description = "List of instance types for the eks nodes."
}

variable "worker_node_ami_type" {
  description = "AMI type of the worker nodes."
  type        = string
}

variable "worker_security_group_ids" {
  type        = list(string)
  description = "List of worker security groups."
}

variable "node_group_desired_size" {
  description = "Desired number of worker nodes for eks cluster"
  type        = number
}

variable "node_group_min_size" {
  description = "Min number of worker nodes for eks cluster"
  type        = number
}

variable "node_group_max_size" {
  description = "Max number of worker nodes for eks cluster"
  type        = number
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
}

variable "eks_alb_namespace" {
  description = "Namespace of the EKS Service Account."
  type        = string
  default     = "kube-system"
}

variable "region" {
  description = "Region."
}

variable "eks_alb_service_account_name" {
  description = "The name of the EKS ALB Service Account."
}

variable "public_access_cidr_blocks" {
  description = "List of cidr blocks for public access to the environment."
  type        = list(string)
}

variable "outpost_config" {
  description = "Configuration for the AWS Outpost to provision the cluster on"
  type        = any
  default     = {}
}

variable "cluster_addons" {
  description = "Map of cluster addon configurations to enable for the cluster. Addon name can be the map keys or set with `name`"
  type        = any
  default     = {}
}

variable "cluster_addons_timeouts" {
  description = "Create, update, and delete timeout configurations for the cluster addons"
  type        = map(string)
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resource."
  default     = {}
}