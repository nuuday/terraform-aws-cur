locals {
  athena_views = toset([
    "compute_savings_plan_eligible_spend_sp_ri.sql",
    "ec2_running_cost_sp_ri.sql",
    "ri_sp_mapping_sp_ri.sql",
    "s3_sp_ri.sql",
    "summary_view_sp_ri.sql",
  ])
}

resource "local_file" "compute_savings_plans" {
  for_each = local.athena_views

  content = templatefile("${path.module}/views/${each.key}", {
    athena_cur_table_name = aws_glue_catalog_database.cur.name
  })
  filename        = "${path.module}/.generated/${each.key}"
  file_permission = "0600"
}
