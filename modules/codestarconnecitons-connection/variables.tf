variable "environment" {
  type        = string
  description = "Name of the Environment"
}

variable "application" {
  description = "The name of the application."
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resource."
  default     = {}
}