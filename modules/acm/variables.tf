variable "environment" {
  type        = string
  description = "Name of the Environment"
}

variable "application" {
  description = "The name of the application."
}

variable "region" {
  description = "AWS region to deploy the ACM certificate"
  type        = string
}

variable "domain_name" {
  description = "Domain name for certificate."
}

variable "route53_zone_id" {
  description = "Route53 zone id for domain validation."
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resource."
  default     = {}
}