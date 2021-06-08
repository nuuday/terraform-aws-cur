terraform {
  required_version = ">= 0.13, < 2.0"
}

module "this" {
  source = "../../"



  use_existing_s3_bucket  = true
  s3_bucket_name          = "nuuday-cost-usage-reports"
  s3_bucket_prefix        = "reports"
  s3_use_existing_kms_key = true
  s3_kms_key_alias        = "aws/s3"

  report_name      = "example"
  report_frequency = "HOURLY"
  report_additional_artifacts = [
    "ATHENA",
  ]

  report_format      = "Parquet"
  report_compression = "Parquet"
  report_versioning  = "OVERWRITE_REPORT"
}
