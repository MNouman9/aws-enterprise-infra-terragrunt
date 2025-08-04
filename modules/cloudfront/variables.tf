variable "environment" {
  type        = string
  description = "Name of the Environment"
}

variable "application" {
  description = "The name of the application."
}

variable "dist_name" {
  description = "The name of the distribution."
}

variable "domain_name" {
  description = "The name of the domain."
}

variable "logging_bucket_id" {
  type        = string
  description = "ID of the bucket used for logging."
}

variable "logging_bucket_domain_name" {
  description = "Domain name of the bucket used for logging."
}

variable "route53_zone_id" {
  description = "Route53 zone id for domain validation."
}

variable "certificate_arn" {
  type        = string
  description = "Arn of the certificate"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resource."
  default     = {}
}