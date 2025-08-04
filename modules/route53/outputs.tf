output "route53_zone_id" {
  description = "Zone ID of Route53 zone"
  value       = aws_route53_zone.this.id
}

output "route53_zone_name_servers" {
  description = "Name servers of Route53 zone"
  value       = aws_route53_zone.this.name_servers
}

output "route53_zone_name" {
  description = "Name of Route53 zone"
  value       = aws_route53_zone.this.name
}

output "route53_record_name" {
  description = "The name of the record"
  value       = { for k, v in aws_route53_record.this : k => v.name }
}

output "route53_record_fqdn" {
  description = "FQDN built using the zone domain and name"
  value       = { for k, v in aws_route53_record.this : k => v.fqdn }
}
