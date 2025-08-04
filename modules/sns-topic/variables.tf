variable "environment" {
  type        = string
  description = "Name of the Environment"
}

variable "application" {
  type = string
}
variable "email_list" {
  type        = list(string)
  description = "Comma separated list of email addresses to send notifications to"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resource."
  default     = {}
}