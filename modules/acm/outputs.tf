output "certificate_arn" {
  description = "The ARN of the ACM certificate"
  value       = aws_acm_certificate.default.arn
}

output "validation_records" {
  description = "The Route 53 validation records"
  value       = aws_route53_record.validation
}
