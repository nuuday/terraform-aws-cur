resource "aws_s3_bucket" "cur" {
  count = var.use_existing_s3_bucket ? 0 : 1

  bucket = var.s3_bucket_name

  tags = var.tags
}
