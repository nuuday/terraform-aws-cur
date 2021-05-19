# Exist only to make the linter think we use the 'aws' provider.
# Will be removed once we fill in proper resources.
resource "aws_s3_bucket" "null" {
  count = 0

  bucket_prefix = "null"
}
