variable "environment" {
  type        = string
  description = "Name of the Environment"
}

variable "application" {
  description = "The name of the application."
}

variable "username" {
  description = "Username for the master DB user."
  sensitive   = true
}

variable "password" {
  description = "Password for the master DB user."
  sensitive   = true
}

variable "engine" {
  type        = string
  description = "Database engine type (e.g. docdb)"
}

variable "engine_version" {
  type        = string
  description = "Database Engine Version"
}

variable "instance_class" {
  description = "The instance type of the RDS instance."
}

variable "backup_retention_period" {
  type        = number
  description = "Number of days to retain backups for."
}

variable "preferred_backup_window" {
  type        = string
  description = "The daily time range during which automated backups are created."
}
variable "maintenance_window" {
  type        = string
  description = "The daily time range during which maintenance are applied."
}
variable "subnet_ids" {
  type        = list(string)
  description = "A list of VPC subnet IDs."
}

variable "skip_final_snapshot" {
  default     = false
  description = "If `true` no final snapshot will be taken on termination"
  type        = bool
}

variable "securitygroup_ids" {
  type        = list(string)
  description = "A list of Security Group IDs."
}

variable "key_arn" {
  type        = string
  description = "Kms key used for DocumentDB secrets."
}
variable "snapshot_identifier" {
  type        = string
  description = "Specifies whether or not to create the database from a snapshot."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resource."
  default     = {}
}