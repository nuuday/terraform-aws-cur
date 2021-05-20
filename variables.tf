variable "use_existing_s3_bucket" {
  description = "Whether to use an existing S3 bucket or create a new one. Regardless, `s3_bucket_name` must contain the name of the bucket."
  type        = bool
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket into which CUR will put the cost data."
  type        = string
}

variable "tags" {
  description = "Tags which will be applied to provisioned resources."
  type        = map(string)
  default     = {}
}
