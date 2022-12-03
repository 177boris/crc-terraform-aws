# Certificate ARN 
# arn:aws:acm:us-east-1:216761891772:certificate/32656f1c-e651-4d89-9741-15c7e9b5cf3d 

# Find a certificate issued by (not imported into) ACM

/* 
data "aws_acm_certificate" "amazon_issued" {
  domain      = "oabcloudresumechallenge.com"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

data "aws_route53_zone" "example" {
  name         = "oabcloudresumechallenge.com"
  private_zone = false
}

data "aws_route53_zone" "example1" {
  name         = "www.oabcloudresumechallenge.com"
  private_zone = false
}

resource "aws_acm_certificate" "certificate" {
  domain_name               = "oabcloudresumechallenge.com"
  subject_alternative_names = ["oabcloudresumechallenge.com", "www.oabcloudresumechallenge.com"]
  validation_method         = "DNS"
}

resource "aws_route53_record" "example" {
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      zone_id = dvo.domain_name == "oabcloudresumechallenge.com" ? data.aws_route53_zone.example.zone_id : data.aws_route53_zone.example1.zone_id
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id
}

resource "aws_acm_certificate_validation" "example" {
  certificate_arn         = data.aws_acm_certificate.amazon_issued.arn
  validation_record_fqdns = [for record in aws_route53_record.example : record.fqdn]
}

*/ 