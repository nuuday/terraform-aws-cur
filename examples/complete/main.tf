terraform {
  required_version = "~> 0.13, ~> 0.14, ~> 0.15"
}

module "this" {
  source = "../../"

  use_existing_s3_bucket = true
  s3_bucket_name         = "foo"
}
