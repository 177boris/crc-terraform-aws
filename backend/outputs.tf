output "bucket_name" {
  value = aws_s3_bucket.website.id
}

output "s3_domain" {
  value = aws_s3_bucket.website.bucket_regional_domain_name
}

output "cloudfront_distribution" {
  value = aws_cloudfront_distribution.s3_distribution.id
}


# output Cloud front URL if domain/alias is not configured
output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

