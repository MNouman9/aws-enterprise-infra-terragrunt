variable "create" {
  description = "Whether to create Route53 zone"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags added to all zones. Will take precedence over tags from the 'zones' variable"
  type        = map(any)
  default     = {}
}

variable "zone_name" {
  description = "The domain name of the Route53 zone"
  type        = string
}

variable "comment" {
  type    = string
  default = null
}

variable "force_destroy" {
  type    = bool
  default = false
}

variable "private_zone" {
  description = "Whether Route53 zone is private or public"
  type        = bool
  default     = false
}

variable "records" {
  description = "List of maps of DNS records"
  type        = any
  default     = []
}