resource "aws_kms_key" "eks" {
  description             = "EKS Secret Encryption Key"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  tags = merge(
    var.tags,
    {
      name = "eks-key-${var.application}-${var.environment}"
    }
  )
}

resource "aws_kms_key" "documentdb" {
  description             = "DocumentDB Secret Encryption Key"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  tags = merge(
    var.tags,
    {
      name = "docdb-key-${var.application}-${var.environment}"
    }
  )
}

resource "aws_kms_key" "postgres" {
  description             = "PostgreSQL Secret Encryption Key"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  tags = merge(
    var.tags,
    {
      name = "postgres-key-${var.application}-${var.environment}"
    }
  )
}