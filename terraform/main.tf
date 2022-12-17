# =================================================================
# CloudFront Config 

resource "aws_cloudfront_origin_access_control" "s3_distribution_oac" {
  name                              = "OAC-CloudFront"
  description                       = "Origin access control for AWS CloudFront"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {

  aliases             = [var.domain_name, "www.${var.domain_name}"]
  price_class         = "PriceClass_100"    # See https://aws.amazon.com/cloudfront/pricing/
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CDN for ${local.name_prefix}"
  default_root_object = "index.html"


  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.website.bucket_regional_domain_name

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

    forwarded_values {
      query_string = false
      #headers = [ "Origin", "Access-Control-Request-Method", "Access-Control-Request-Headers" ]

      cookies {
        forward = "none"
      }
    }

  }


  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = local.common_tags

  /*
  custom_error_response {
    error_caching_min_ttl = 0
    error_code = 404
    response_code = 200
    response_page_path = "/error.html"
  } 
  */


  origin {
    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1.1", "TLSv1.2"]
    }
    domain_name              = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.website.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_distribution_oac.id

  }


  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"
  }

  depends_on = [
    aws_s3_bucket.website
  ]

}

