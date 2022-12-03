# S3 Bucket 

resource "aws_s3_bucket" "website" {
  bucket = local.s3_bucket_name

  tags = local.common_tags
}

resource "aws_s3_bucket_acl" "website" {
  bucket = aws_s3_bucket.website.id
  acl    = "private"
}


data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.s3_distribution.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "s3_policy" {
  bucket = aws_s3_bucket.website.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_s3_object" "webpage" {
  bucket = aws_s3_bucket.website.id
  key    = "index.html"
  source = "website/index.html"

  content_type = "text/html"

  tags = local.common_tags
}

resource "aws_s3_object" "image" {
  bucket = aws_s3_bucket.website.id
  key    = "icon3.png"
  source = "website/icon3.png"

  tags = local.common_tags
}

resource "aws_s3_bucket_website_configuration" "s3_website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_cors_configuration" "website" {
  bucket = aws_s3_bucket.website.bucket


  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }

}

resource "aws_s3_bucket_public_access_block" "website_public_access_block" {
  bucket = aws_s3_bucket.website.id

  block_public_acls   = true
  block_public_policy = true
}


################################ 
# CloudFront Config 

resource "aws_cloudfront_origin_access_control" "s3_distribution_oac" {
  name                              = "OAC-CloudFront"
  description                       = "Origin access control for AWS CloudFront"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {

  price_class = "PriceClass_All"

  origin {
    domain_name              = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id                = local.s3_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_distribution_oac.id
  }

  /* 
  custom_origin_config {
      http_port = "80"
      https_port = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  */

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CDN for ${local.name_prefix}"
  default_root_object = "index.html"

  /* 
  logging_config {
    include_cookies = false
    bucket          = "mylogs.s3.amazonaws.com"
    prefix          = "myprefix"
  } */

  #aliases = ["oabcloudresumechallenge.com", "www.oabcloudresumechallenge.com"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = local.common_tags


  viewer_certificate {
    cloudfront_default_certificate = true #cloudfront_default_certificate = data.aws_acm_certificate.amazon_issued.arn
  }


}

