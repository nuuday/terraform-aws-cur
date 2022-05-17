locals {
  # View templates for Athena. Fetched from:
  # https://github.com/aws-samples/aws-cudos-framework-deployment/tree/3a1b408a71f0ed36fbda4094c2428b561ecfbaa7/cudos/view-templates
  athena_view_template_paths = toset([
    "views/compute_savings_plan_eligible_spend_sp_ri.sql",
    "views/ec2_running_cost_sp_ri.sql",
    "views/ri_sp_mapping_sp_ri.sql",
    "views/s3_sp_ri.sql",
    "views/summary_view_sp_ri.sql",
    "views/account_map.sql",
  ])
}

resource "local_file" "athena_views" {
  for_each = local.athena_view_template_paths

  content = templatefile("${path.module}/${each.key}", {
    athena_cur_table_name = var.glue_destination_table
  })

  filename        = "${path.module}/.generated/${each.key}"
  file_permission = "0600"
}

resource "null_resource" "athena_views" {
  for_each = local.athena_view_template_paths

  triggers = {
    checksum = filesha256(each.key)
  }

  provisioner "local-exec" {
    command = join(" ", [
      "aws athena start-query-execution",
      "--query-execution-context Database=${aws_glue_catalog_database.cur.name},Catalog=AwsDataCatalog",
      "--work-group primary --query-string \"file://${local_file.athena_views[each.key].filename}\"",
      "--region ${data.aws_region.current.name}",
    ])
  }
}
