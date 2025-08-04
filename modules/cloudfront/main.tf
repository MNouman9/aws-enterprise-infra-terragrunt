resource "random_id" "S3_random_id" {
  byte_length = 4
}

resource "aws_s3_bucket" "cloudfront_bucket" {
  bucket        = "${var.application}-${var.dist_name}-${var.environment}-${random_id.S3_random_id.dec}"
  force_destroy = true
  tags = merge(
    var.tags,
    {
      Name = "${var.application}-${var.dist_name}-${var.environment}"
    }
  )
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.cloudfront_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "cloudfront_bucket" {
  bucket     = aws_s3_bucket.cloudfront_bucket.bucket
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.this]
}

resource "aws_s3_bucket_versioning" "cloudfront_bucket" {
  bucket = aws_s3_bucket.cloudfront_bucket.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_logging" "cloudfront_bucket" {
  bucket        = aws_s3_bucket.cloudfront_bucket.bucket
  target_bucket = var.logging_bucket_id
  target_prefix = "logs/cf_bucket/"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloudfront_bucket" {
  bucket = aws_s3_bucket.cloudfront_bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.cloudfront_bucket.bucket_regional_domain_name
    origin_id   = "${var.application}-${var.dist_name}-frontend-${var.environment}"
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.app_oai.cloudfront_access_identity_path
    }
  }
  enabled             = true
  is_ipv6_enabled     = true
  comment             = ""
  default_root_object = "index.html"
  web_acl_id          = aws_wafv2_web_acl.default.arn
  aliases             = [var.domain_name]
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.application}-${var.dist_name}-frontend-${var.environment}"
    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
  restrictions {
    geo_restriction {
      restriction_type = "blacklist"
      locations        = ["RU"]
    }
  }
  viewer_certificate {
    acm_certificate_arn      = var.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }
  custom_error_response {
    error_code         = 403
    response_page_path = "/index.html"
    response_code      = 200
  }
  logging_config {
    bucket = var.logging_bucket_domain_name
    prefix = "logs/cf_distribution/${var.dist_name}"
  }
  tags = var.tags
}

resource "aws_cloudfront_origin_access_identity" "app_oai" {
  comment = "OAI for ${var.domain_name}"
}

resource "aws_s3_bucket_policy" "cloudfront_s3policy" {
  bucket = aws_s3_bucket.cloudfront_bucket.id
  policy = data.aws_iam_policy_document.cloudfront_s3policy_document.json
}

resource "aws_wafv2_web_acl" "default" {
  provider    = aws.us-east-1
  name        = "${var.application}-${var.dist_name}-cloudfront-managed-rule-${var.environment}"
  description = "Managed rule."
  scope       = "CLOUDFRONT"
  default_action {
    allow {}
  }
  rule {
    name     = "${var.application}-${var.dist_name}-cloudfront-waf-rule-1-${var.environment}"
    priority = 1
    override_action {
      count {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.application}-${var.dist_name}-waf-rule-1-${var.environment}"
      sampled_requests_enabled   = false
    }
  }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.application}-${var.dist_name}-cloudfront-waf-web-acl-${var.environment}"
    sampled_requests_enabled   = true
  }
  tags = var.tags
}
