output "bucket_id" {
  value = aws_s3_bucket.logging.id
}

output "bucket_arn" {
  value = aws_s3_bucket.logging.arn
}

output "bucket_domain_name" {
  value = aws_s3_bucket.logging.bucket_domain_name
}

output "waf_logs_kinesis_firehose_delivery_stream_arn" {
  value = aws_kinesis_firehose_delivery_stream.waf.arn
}