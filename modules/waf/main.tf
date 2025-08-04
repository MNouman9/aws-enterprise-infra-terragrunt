resource "aws_wafv2_web_acl" "default" {
  name        = "${var.application}-managed-rule-${var.environment}"
  description = "Managed rule."
  scope       = "REGIONAL"
  default_action {
    allow {}
  }
  dynamic "rule" {
    for_each = var.managed_rule_groups
    content {
      name     = "${var.application}-waf-rule-${rule.key}-${var.environment}"
      priority = rule.key + 1

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = rule.value["name"]
          vendor_name = rule.value["vendor_name"]
          dynamic "rule_action_override" {
            for_each = lookup(rule.value, "rule_action_overrides", [])
            content {
              name = rule_action_override.value["name"]
              action_to_use {
                count {}
              }
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "${var.application}-waf-rule-${rule.key}-${var.environment}"
        sampled_requests_enabled   = true
      }
    }
  }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.application}-waf-web-acl-${var.environment}"
    sampled_requests_enabled   = true
  }
  tags = var.tags
}

resource "aws_wafv2_web_acl_logging_configuration" "default" {
  log_destination_configs = [var.kinesis_firehose_delivery_stream_arn]
  resource_arn            = aws_wafv2_web_acl.default.arn
}