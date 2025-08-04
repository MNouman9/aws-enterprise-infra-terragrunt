variable "environment" {
  type        = string
  description = "Name of the Environment"
}

variable "allocated_storage" {
  type        = number
  default     = 10
  description = "The allocated storage for the database."
}

variable "instance_class" {
  description = "The instance type of the RDS instance."
}

variable "application" {
  description = "The name of the application."
}

variable "engine" {
  type        = string
  description = "Database engine type (e.g. postgres)"
}

variable "engine_version" {
  type        = string
  description = "Database Engine Version"
}

variable "username" {
  description = "Username for the master DB user."
  sensitive   = true
}

variable "password" {
  description = "Password for the master DB user."
  sensitive   = true
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
variable "securitygroup_ids" {
  type        = list(string)
  description = "A list of Security Group IDs."
}
variable "skip_final_snapshot" {
  default     = false
  description = "If `true` no final snapshot will be taken on termination"
  type        = bool
}
variable "key_arn" {
  type        = string
  description = "Kms key used for storage encryption."
}
variable "snapshot_identifier" {
  type        = string
  description = "Specifies whether or not to create the database from a snapshot."
  default     = null
}
variable "create_db_snapshot_restore" {
  default     = false
  description = "If `true` a snapshot restore will be created."
  type        = bool
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resource."
  default     = {}
}