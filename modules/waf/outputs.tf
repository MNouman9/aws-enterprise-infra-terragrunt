output "waf_acl_id" {
  value = aws_wafv2_web_acl.default.id
}

output "waf_acl_arn" {
  value = aws_wafv2_web_acl.default.arn
}