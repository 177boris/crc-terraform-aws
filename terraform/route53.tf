
resource "aws_route53_zone" "main" {
  name = var.domain_name
  tags = local.common_tags
}

/*
resource "aws_route53domains_registered_domain" "this" {
  domain_name = var.domain_name

  tags = local.common_tags
} */

# Create a resource to import the SSL Certificate CNAME record
resource "aws_route53_record" "sslrecord" {
  zone_id         = aws_route53_zone.main.zone_id
  name            = "_28b47d3ea73919d1bb984fef8559b9cc"
  type            = "CNAME"
  ttl             = 300
  records         = ["_4d0352c584f71bfdefc465280618f505.gbycpywhzv.acm-validations.aws."]
  allow_overwrite = false
}

resource "aws_route53_record" "root-a" {
  zone_id         = aws_route53_zone.main.zone_id
  name            = var.domain_name
  type            = "A"
  allow_overwrite = true
  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "root-aaaa" {
  zone_id         = aws_route53_zone.main.zone_id
  name            = var.domain_name
  type            = "AAAA"
  allow_overwrite = true
  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www-a" {
  zone_id         = aws_route53_zone.main.zone_id
  name            = "www.${var.domain_name}"
  type            = "A"
  allow_overwrite = true
  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www-aaaa" {
  zone_id         = aws_route53_zone.main.zone_id
  name            = "www.${var.domain_name}"
  type            = "AAAA"
  allow_overwrite = true
  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}


################################ ACM Certificate 

/* 
//ACM certificate with Amazon Cloudfront is only supported on us-east-1
//https://docs.aws.amazon.com/acm/latest/userguide/acm-regions.html
provider "aws" {
  alias = "cloudfront_provider"
  region = "us-east-1"
}

# SSL Certificate
resource "aws_acm_certificate" "ssl_certificate" {
  provider = aws.cloudfront_provider
  domain_name = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  #validation_method = "EMAIL
  validation_method = "DNS"

  tags = local.common_tags

  lifecycle {
    create_before_destroy = true
  }
}

# Uncomment the validation_record_fqdns line if you decide to use DNS validation instead of email
resource "aws_acm_certificate_validation" "cert_validation" {
  provider = aws.cloudfront_provider
  certificate_arn = aws_acm_certificate.ssl_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.ssl_certificate.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      zone_id = var.main_zone_id
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id
}

*/