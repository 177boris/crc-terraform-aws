output "bucket_name" {
  value = aws_s3_bucket.website.id
}

output "lambda_bucket_name" {
  description = "Name of the S3 bucket used to store function code."

  value = aws_s3_bucket.lambda_bucket.id
}

output "function_name" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.get_function.function_name
}

output "base_url" {
  description = "Base URL for API Gateway stage."

  value = aws_apigatewayv2_stage.lambda.invoke_url
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

