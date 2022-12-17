# S3 Bucket 

resource "aws_s3_bucket" "website" {
  bucket = local.s3_bucket_name

  tags = local.common_tags
}

resource "aws_s3_bucket_acl" "website" {
  bucket = aws_s3_bucket.website.id
  acl    = "public-read"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "website_encryption_config" {
  bucket = aws_s3_bucket.website.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


data "aws_iam_policy_document" "s3_policy" {
  statement {
    sid     = "AllowPublicRead1"
    effect  = "Allow"
    actions = ["s3:GetObject"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    resources = [
      "${aws_s3_bucket.website.arn}",
      "${aws_s3_bucket.website.arn}/*"
    ]
  }

  /* 
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
  } */

}

resource "aws_s3_bucket_policy" "s3_policy" {
  bucket = aws_s3_bucket.website.id
  policy = data.aws_iam_policy_document.s3_policy.json
}


resource "aws_s3_object" "webpage_home" {
  bucket = aws_s3_bucket.website.id
  key    = "index.html"
  source = "website/index.html"

  content_type = "text/html"

  tags = local.common_tags
}


resource "aws_s3_object" "visitor_counter_js" {
  bucket = aws_s3_bucket.website.id
  key    = "counter.js"
  source = "website/counter.js"

  content_type = "text/javascript"
  tags         = local.common_tags
}


resource "aws_s3_object" "image" {
  bucket = aws_s3_bucket.website.id
  key    = "icon3.png"
  source = "website/icon3.png"

  tags = local.common_tags
}

resource "aws_s3_object" "error_page" {
  bucket = aws_s3_bucket.website.id
  key    = "error.html"
  source = "website/error.html"

  content_type = "text/html"

  tags = local.common_tags
}

resource "aws_s3_bucket_website_configuration" "s3_website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}



/* 
resource "aws_s3_bucket_cors_configuration" "website" {
  bucket = aws_s3_bucket.website.bucket

  cors_rule {
    allowed_methods = ["GET", "POST", "HEAD"]
    allowed_origins = ["*"]
  }

}


resource "aws_s3_bucket_public_access_block" "website_public_access_block" {
  bucket = aws_s3_bucket.website.id

  block_public_acls   = true
  block_public_policy = true
}
*/