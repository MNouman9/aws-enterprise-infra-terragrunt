variable "environment" {
  type        = string
  description = "Name of the Environment"
}

variable "service_name" {
  description = "Name of kubernetes service."
}

variable "namespace" {
  description = "Name of kubernetes namespace."
}

variable "certificate_arn" {
  type        = string
  description = "Certificate arn for the ssl certificate used for https."
}

variable "ingress_group_name" {
  type        = string
  description = "Name of the Group so single Load balancer can be used for every ingress"
}

variable "application" {
  description = "The name of the application."
}

variable "app_name" {
  description = "The name of the application"
}

variable "waf_acl_arn" {
  type        = string
  description = "ARN of waf acl."
  default     = null
}
variable "healthcheck_path" {
  type        = string
  description = "Healthcheck path"
  default     = "/"
}
variable "route53_zone_id" {
  type        = string
  description = "Route53 zone id."
}

variable "record" {
  type        = string
  description = "Load Balancer endpoint"
  default     = null
}

variable "lb_name" {
  type        = string
  description = "Load Balancer Name"
}

variable "url" {
  type        = string
  description = "Route53 URL entry."
}