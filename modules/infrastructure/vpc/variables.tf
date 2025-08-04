variable "environment" {
  type        = string
  description = "Name of the Environment"
}

variable "region" {
  description = "AWS region for all resources"
}

variable "application" {
  description = "Application name."
}

variable "cidr_block" {
  description = "cidr block for vpc"
}

variable "cidr_block_private_subnet_a" {
  description = "cidr block for private subnet a"
}

variable "cidr_block_private_subnet_b" {
  description = "cidr block for private subnet b"
}

variable "cidr_block_private_subnet_c" {
  description = "cidr block for private subnet c"
}

variable "cidr_block_public_subnet_a" {
  description = "cidr block for public subnet a"
}

variable "cidr_block_public_subnet_b" {
  description = "cidr block for public subnet b"
}

variable "cidr_block_public_subnet_c" {
  description = "cidr block for public subnet c"
}


variable "logging_bucket_arn" {
  type        = string
  description = "Arn of the bucket used for logging."
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resource."
  default     = {}
}
