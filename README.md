# AWS Cost & Usage Reports

This Terraform module stands up a Cost and Usage Report, together with necessary services making the CUR data queryable in Athena.

## Overview

The overall architecture looks like the illustration below
![AWS Cost and Usage Reports overview](./assets/overview.png)

1. AWS delivers Cost and Usage Reports data to the S3 bucket continuously
2. Whenever new CUR data is delivered, a Glue Crawler makes sure the newly available CUR data is processed and made available in the Data Catalog
3. Athena provides an SQL interface to the CUR data, using the Data Catalog as its data source
4. QuickSight visualizes the data returned from querying Athena

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13, < 0.16 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.29 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.29 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_use_existing_s3_bucket"></a> [use\_existing\_s3\_bucket](#input\_use\_existing\_s3\_bucket) | Whether to use an existing S3 bucket or create a new one. Regardless, `s3_bucket_name` must contain the name of the bucket. | `bool` | n/a | yes |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | Name of the S3 bucket into which CUR will put the cost data. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags which will be applied to provisioned resources. | `map(string)` | `{}` | no |

## Outputs

No outputs.

<!--- END_TF_DOCS --->

## References

It is based on [AWS: Query and Visualize AWS Cost and Usage](https://aws.amazon.com/blogs/big-data/query-and-visualize-aws-cost-and-usage-data-using-amazon-athena-and-amazon-quicksight/).
Check out the blog post and the linked resources for an explanation of the concepts.

For more information about Cost & Usage Reports in general, see [AWS: What are Cost and Usage Reports?](https://docs.aws.amazon.com/cur/latest/userguide/what-is-cur.html)
