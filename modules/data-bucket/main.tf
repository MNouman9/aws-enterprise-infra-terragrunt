resource "random_id" "S3_random_id" {
  byte_length = 4
}

resource "aws_s3_bucket" "data_bucket" {
  bucket        = "${var.application}-data-${var.environment}-${random_id.S3_random_id.dec}"
  force_destroy = false
  tags          = var.tags
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.data_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "data_bucket" {
  bucket     = aws_s3_bucket.data_bucket.bucket
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.this]
}

resource "aws_s3_bucket_versioning" "data_bucket" {
  bucket = aws_s3_bucket.data_bucket.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_logging" "data_bucket" {
  bucket        = aws_s3_bucket.data_bucket.bucket
  target_bucket = var.logging_bucket_id
  target_prefix = "logs/data_bucket/"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "data_bucket" {
  bucket = aws_s3_bucket.data_bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_iam_user" "data_bucket_user" {
  name = "${var.application}-data-${var.environment}"
  tags = var.tags
}

resource "aws_s3_bucket_policy" "data_bucket_policy" {
  bucket = aws_s3_bucket.data_bucket.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicRead",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.data_bucket.id}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "${aws_iam_user.data_bucket_user.arn}"
        ]
      },
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.data_bucket.id}"
      ]
    },
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "${aws_iam_user.data_bucket_user.arn}"
        ]
      },
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:PutObjectAcl"
      ],
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.data_bucket.id}/*"
      ]
    }
  ]
}
EOF
}