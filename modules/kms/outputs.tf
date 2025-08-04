output "eks_key_arn" {
  value = aws_kms_key.eks.arn
}

output "docdb_key_arn" {
  value = aws_kms_key.documentdb.arn
}

output "postgres_key_arn" {
  value = aws_kms_key.postgres.arn
}