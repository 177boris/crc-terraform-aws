# =================================================================
# Lambda bucket && Lambda configuration 
# =================================================================

resource "random_pet" "lambda" {
  prefix = "lambda"
  length = 2
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = random_pet.lambda.id
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "lambda_bucket" {
  bucket = aws_s3_bucket.lambda_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}

# lambda policy 
resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

# lambda role 
resource "aws_iam_policy" "lambda_exec_role" {
  name = "serverless_lambdapattern-ddb-post"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
      {
            "Sid": "WriteLogStreamsAndGroups",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        },
        {
            "Sid": "CreateLogGroup",
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "*"
        },
        {
          "Sid":  "ReadWriteTable",
            "Effect": "Allow",
            "Action": [
                "dynamodb:GetItem",
                "dynamodb:PutItem",
                "dynamodb:UpdateItem"
            ],
            "Resource": "${aws_dynamodb_table.counter_table.arn}"
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_exec_role.arn
}

data "archive_file" "lambda_get_function" {
  type = "zip"

  source_dir  = "${path.module}/lambda"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_s3_object" "this" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "lambda.zip"
  source = data.archive_file.lambda_get_function.output_path

  etag = filemd5(data.archive_file.lambda_get_function.output_path)
}

resource "aws_lambda_function" "get_function" {
  function_name = "GetCount_lambda"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.this.id

  runtime = "python3.9"
  handler = "app.lambda_handler"

  source_code_hash = data.archive_file.lambda_get_function.output_base64sha256

  role = aws_iam_role.lambda_exec.arn

  environment {
    variables = {
      DDB_TABLE = var.table_name
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda-log-group
  ]
}

resource "aws_cloudwatch_log_group" "lambda-log-group" {
  name = "/aws/lambda/GetCount_lambda-logs"

  retention_in_days = var.log_retention
}