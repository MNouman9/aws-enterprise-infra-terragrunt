variable "environment" {
  type        = string
  description = "Name of the Environment"
}

variable "application" {
  description = "Application name."
  type        = string
}

variable "iam_user_names" {
  description = "IAM user names."
  type        = list(string)
}
variable "ec2_instances" {
  description = "EC2 instances."
  type        = list(string)
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resource."
  default     = {}
}