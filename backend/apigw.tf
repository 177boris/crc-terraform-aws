# =================================================================
# API Gateway 

resource "aws_apigatewayv2_api" "http_lambda" {
  name          = "serverless_apigw_lambda-${random_pet.lambda.id}"
  protocol_type = "HTTP"

  cors_configuration {
    allow_headers = [
      "*"
    ]
    allow_methods = [
      "*"
    ]

  }

  /* 
   cors_configuration {
    allow_credentials = false
    allow_headers     = ["*"]
    allow_methods = [
      "GET",
      "HEAD",
      "OPTIONS",
      "POST",
    ]
    allow_origins  = ["*", ]
    expose_headers = []
    max_age        = 0
  }
  */
}

resource "aws_apigatewayv2_stage" "default" {
  api_id = aws_apigatewayv2_api.http_lambda.id

  name        = "serverless_lambda_stage"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.lambda-log-group.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
  depends_on = [aws_cloudwatch_log_group.api_gw]
}

resource "aws_apigatewayv2_integration" "apigw_lambda" {
  api_id      = aws_apigatewayv2_api.http_lambda.id
  description = "Lambda to handle DynamoDB operations"

  integration_uri    = aws_lambda_function.get_function.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "get" {
  api_id = aws_apigatewayv2_api.http_lambda.id

  route_key = "GET /count"
  target    = "integrations/${aws_apigatewayv2_integration.apigw_lambda.id}"
}

resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.http_lambda.id}-logs"

  retention_in_days = var.log_retention
}