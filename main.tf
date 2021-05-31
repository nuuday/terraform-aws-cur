resource "aws_cur_report_definition" "this" {
  report_name                = var.report_name
  time_unit                  = var.report_frequency
  format                     = var.report_format
  compression                = var.report_compression
  report_versioning          = var.report_versioning
  additional_artifacts       = var.report_additional_artifacts
  additional_schema_elements = ["RESOURCES"]

  s3_bucket = var.s3_bucket_name
  s3_region = var.use_existing_s3_bucket ? data.aws_s3_bucket.cur[0].region : aws_s3_bucket.cur[0].region
  s3_prefix = var.s3_bucket_prefix

  depends_on = [
    aws_s3_bucket_policy.cur,
  ]

  provider = aws.cur
}

data "aws_s3_bucket" "cur" {
  count = var.use_existing_s3_bucket ? 1 : 0

  bucket = var.s3_bucket_name
}

data "aws_kms_key" "s3" {
  key_id = "alias/aws/s3"
}

# Versioning and logging disabled.
# tfsec:ignore:AWS077 tfsec:ignore:AWS002
resource "aws_s3_bucket" "cur" {
  count = var.use_existing_s3_bucket ? 0 : 1

  bucket = var.s3_bucket_name
  acl    = "private"

  versioning {
    enabled = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "cur" {
  count = var.use_existing_s3_bucket ? 0 : 1

  bucket = aws_s3_bucket.cur[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "cur" {
  count = var.use_existing_s3_bucket ? 0 : 1

  bucket = aws_s3_bucket.cur[0].id
  policy = data.aws_iam_policy_document.s3_cur[0].json

  depends_on = [aws_s3_bucket_public_access_block.cur]
}

data "aws_iam_policy_document" "s3_cur" {
  count = var.use_existing_s3_bucket ? 0 : 1

  statement {
    principals {
      type        = "Service"
      identifiers = ["billingreports.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketAcl",
      "s3:GetBucketPolicy",
    ]

    resources = [aws_s3_bucket.cur[0].arn]
  }

  statement {
    principals {
      type        = "Service"
      identifiers = ["billingreports.amazonaws.com"]
    }

    actions = ["s3:PutObject"]

    resources = ["${aws_s3_bucket.cur[0].arn}/*"]
  }
}
