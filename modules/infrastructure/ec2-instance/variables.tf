variable "environment" {
  type        = string
  description = "Name of the Environment"
}

variable "application" {
  description = "The name of the application."
}

variable "ami" {
  type        = string
  description = "Ami id for the instance."
}

variable "associate_public_ip_address" {
  type        = bool
  default     = false
  description = "Enable or disable public ip association."
}

variable "instance_type" {
  type        = string
  description = "Intance type"
  default     = "t4g.nano"
}

variable "key_name" {
  type        = string
  description = "Name of the ssh public key."
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group ids."
}

variable "subnet_id" {
  type        = string
  description = "Id of the vpc subnet."
}

variable "server_type" {
  type        = string
  description = "Server type"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resource."
  default     = {}
}