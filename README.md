# AWS Cost & Usage Reports

This Terraform module stands up a Cost and Usage Report, together with necessary services making the CUR data queryable in Athena.

## Overview

The overall architecture looks like the illustration below
![AWS Cost and Usage Reports overview](./assets/overview.png)

1. AWS delivers Cost and Usage Reports data to the S3 bucket continuously
2. Whenever new CUR data is delivered, a Glue Crawler makes sure the newly available CUR data is processed and made available in the Data Catalog
3. Athena provides an SQL interface to the CUR data, using the Data Catalog as its data source
4. QuickSight visualizes the data returned from querying Athena

<!-- BEGIN_TF_DOCS --->
<!-- END_TF_DOCS --->

## References

It is based on [AWS: Query and Visualize AWS Cost and Usage](https://aws.amazon.com/blogs/big-data/query-and-visualize-aws-cost-and-usage-data-using-amazon-athena-and-amazon-quicksight/).
Check out the blog post and the linked resources for an explanation of the concepts.

For more information about Cost & Usage Reports in general, see [AWS: What are Cost and Usage Reports?](https://docs.aws.amazon.com/cur/latest/userguide/what-is-cur.html)
