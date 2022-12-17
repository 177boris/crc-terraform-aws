resource "random_integer" "rand" {
  min = 700
  max = 999
}

locals {

  common_tags = {
    managed_by = "Terraform"
    project    = "Boris-${var.project}"
  }

  s3_origin_id   = "OAB-Dev-S3-Origin"
  s3_bucket_name = lower("${var.domain_name}")

  name_prefix = var.naming_prefix

}
