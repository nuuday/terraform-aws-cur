# Changelog

## 0.1.0 (2021-05-31)


### Features

* optionally provision S3 bucket for CUR data ([#3](https://www.github.com/nuuday/terraform-aws-cur/issues/3)) ([96f16ee](https://www.github.com/nuuday/terraform-aws-cur/commit/96f16ee42f238454bab82bef2a985d32275a92c5))
* populate Athena Table with CUR data ([#6](https://www.github.com/nuuday/terraform-aws-cur/issues/6)) ([ffec446](https://www.github.com/nuuday/terraform-aws-cur/commit/ffec44651e3d51ce067d8e856b86fb30585987c8))


### Fixes

* actually create report definition ([#9](https://www.github.com/nuuday/terraform-aws-cur/issues/9)) ([a89251a](https://www.github.com/nuuday/terraform-aws-cur/commit/a89251a177eae79b7ca1e86b8d38994dada34079))
* prevent Lambda from erroring out if Crawler is already running ([#11](https://www.github.com/nuuday/terraform-aws-cur/issues/11)) ([a914ae3](https://www.github.com/nuuday/terraform-aws-cur/commit/a914ae38fb67a03542e0fe51d685ad76c3d29c55))


### Improvements

* output useful values from provisioned resources ([#19](https://www.github.com/nuuday/terraform-aws-cur/issues/19)) ([7904c5e](https://www.github.com/nuuday/terraform-aws-cur/commit/7904c5efa974cdcc1458b551a8f7d1fd882fe845))
