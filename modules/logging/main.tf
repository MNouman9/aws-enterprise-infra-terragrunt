data "aws_cloudfront_log_delivery_canonical_user_id" "cloudfront_log_delivery" {}

resource "random_id" "S3_random_id" {
  byte_length = 4
}

resource "aws_s3_bucket" "logging" {
  bucket = "${var.application}-logging-${var.environment}-${random_id.S3_random_id.dec}"

  force_destroy = true
  tags          = var.tags
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.logging.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "logging" {
  bucket     = aws_s3_bucket.logging.bucket
  acl        = "log-delivery-write"
  depends_on = [aws_s3_bucket_ownership_controls.this]
}

resource "aws_s3_bucket_versioning" "logging" {
  bucket = aws_s3_bucket.logging.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "logging" {
  bucket                  = aws_s3_bucket.logging.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logging" {
  bucket = aws_s3_bucket.logging.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "logging" {
  bucket = aws_s3_bucket.logging.bucket
  rule {
    id     = "delete-old-logs"
    status = "Enabled"

    filter {
      prefix = ""
    }
    expiration {
      days = 30
    }
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

resource "aws_iam_role" "firehose" {
  name = "${var.application}-firehose-stream-role-${var.environment}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags               = var.tags
}

resource "aws_iam_role_policy" "custom-policy" {
  name   = "${var.application}-firehose-role-custom-policy-${var.environment}"
  role   = aws_iam_role.firehose.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "s3:AbortMultipartUpload",
        "s3:GetBucketLocation",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:ListBucketMultipartUploads",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.logging.arn}",
        "${aws_s3_bucket.logging.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": "iam:CreateServiceLinkedRole",
      "Resource": "arn:aws:iam::*:role/aws-service-role/wafv2.amazonaws.com/AWSServiceRoleForWAFV2Logging"
    }
  ]
}
EOF
}

resource "aws_kinesis_firehose_delivery_stream" "waf" {
  name        = "aws-waf-logs-${var.application}-${var.environment}"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose.arn
    bucket_arn = aws_s3_bucket.logging.arn
  }
  tags = var.tags
}
