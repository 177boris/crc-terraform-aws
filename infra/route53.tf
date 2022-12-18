resource "aws_route53_record" "websiteurl" {
  name    = var.endpoint
  zone_id = data.aws_route53_zone.domain.zone_id
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "root-a" {
  name    = var.domain_name
  zone_id = data.aws_route53_zone.domain.zone_id
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}


data "aws_route53_zone" "domain" {
  name         = var.domain_name
  private_zone = false
}


/*
# Create a resource to import the SSL Certificate CNAME record
resource "aws_route53_record" "sslrecord" {
  zone_id         = data.aws_route53_record.domain.zone_id
  name            = "_28b47d3ea73919d1bb984fef8559b9cc"
  type            = "CNAME"
  ttl             = 300
  records         = ["_4d0352c584f71bfdefc465280618f505.gbycpywhzv.acm-validations.aws."]
  allow_overwrite = false
}

resource "aws_route53domains_registered_domain" "this" {
  domain_name = var.domain_name

  tags = local.common_tags
} */
