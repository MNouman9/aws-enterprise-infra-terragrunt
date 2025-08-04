variable "environment" {
  type        = string
  description = "Name of the Environment"
}

variable "application" {
  description = "The application for deployment."
}

variable "logging_bucket_id" {
  description = "Id of the bucket used for logging."
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resource."
  default     = {}
}