variable "environment" {
  type        = string
  description = "Name of the Environment"
}

variable "application" {
  description = "The name of the application."
}
variable "kinesis_firehose_delivery_stream_arn" {
  type        = string
  description = "Kinesis firehose delivery stream arn"
}

variable "managed_rule_groups" {
  type = list(object({
    name        = string
    vendor_name = string
    rule_action_overrides = optional(list(object({
      name          = string
      action_to_use = string
    })), [])
  }))
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resource."
  default     = {}
}