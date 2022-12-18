# =================================================================
# S3 Bucket 
# =================================================================

resource "aws_s3_bucket" "website" {
  bucket = "www.${local.s3_bucket_name}"

  tags = local.common_tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption_config" {
  bucket = aws_s3_bucket.website.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_acl" "website" {
  bucket = aws_s3_bucket.website.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "www_s3block" {
  bucket                  = aws_s3_bucket.website.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 bucket for redirecting non-www to www.
resource "aws_s3_bucket" "root_bucket" {
  bucket = var.domain_name

  tags = local.common_tags
}

resource "aws_s3_bucket_website_configuration" "root_bucket_config" {
  bucket = aws_s3_bucket.root_bucket.id

  redirect_all_requests_to {
    host_name = "https://www.${var.domain_name}"
    protocol  = "https"
  }

}

resource "aws_s3_bucket_public_access_block" "root_s3block" {
  bucket                  = aws_s3_bucket.root_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.root_bucket.id
  acl    = "private"
}


resource "aws_s3_bucket_policy" "s3policy" {
  bucket = aws_s3_bucket.website.id
  policy = data.aws_iam_policy_document.s3policy.json
}

data "aws_iam_policy_document" "s3policy" {
  statement {
    actions = ["s3:GetObject"]

    resources = [
      aws_s3_bucket.website.arn,
      "${aws_s3_bucket.website.arn}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.oai.iam_arn]
    }
  }
}



/*

# Webpage objects 

resource "aws_s3_bucket_object" "resources" {
  for_each = fileset("./../website/", "**")
  bucket = aws_s3_bucket.website.id

  key = each.value
  source = "./../website/${each.value}"
  etag = filemd5("./../website/${each.value}")
}


##### 
resource "aws_s3_object" "webpage_home" {
  bucket = aws_s3_bucket.website.id
  key    = "index.html"
  source = "${abspath(path.root)}/../website/index.html"

  content_type = "text/html"

  tags = local.common_tags
}


resource "aws_s3_object" "v_counter_js" {
  bucket = aws_s3_bucket.website.id
  key    = "counter.js"
  source = "${abspath(path.root)}/../website/counter.js"

  content_type = "text/javascript"
  tags         = local.common_tags
}


resource "aws_s3_object" "image" {
  bucket = aws_s3_bucket.website.id
  key    = "icon3.png"
  source = "${abspath(path.root)}/../website/icon3.png"

  tags = local.common_tags
}

resource "aws_s3_object" "error_page" {
  bucket = aws_s3_bucket.website.id
  key    = "error.html"
  source = "${abspath(path.root)}/../website/error.html"

  content_type = "text/html"

  tags = local.common_tags
}

*/