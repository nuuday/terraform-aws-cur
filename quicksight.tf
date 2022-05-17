locals {
  # Data set templates for QuickSight. Fetched from:
  # https://github.com/aws-samples/aws-cudos-framework-deployment/tree/3a1b408a71f0ed36fbda4094c2428b561ecfbaa7/cudos/dataset-templates
  quicksight_dataset_template_paths = toset([
    "data-sets/summary_view.json",
    "data-sets/s3_view.json",
    "data-sets/ec2_running_cost.json",
    "data-sets/cur.json",
    "data-sets/compute_savings_plan_eligible_spend.json",
  ])
}

resource "local_file" "quicksight_data_source" {
  content = templatefile("${path.module}/data-sets/data-source.json", {
    user_arn = var.quicksight_user_arn
  })
  filename        = "${path.module}/.generated/data-sets/data-source.json"
  file_permission = "0600"
}

resource "null_resource" "quicksight_data_source" {
  triggers = {
    checksum = filesha256("${path.module}/data-sets/data-source.json")
  }

  provisioner "local-exec" {
    command = join(" ", [
      "aws quicksight create-data-source",
      "--cli-input-json file://${local_file.quicksight_data_source.filename}",
      "--region ${data.aws_region.current.name}",
      "--aws-account-id ${data.aws_caller_identity.current.account_id}",
    ])
  }
}

resource "local_file" "quicksight_data_sets" {
  for_each = local.quicksight_dataset_template_paths

  content = templatefile("${path.module}/${each.key}", {
    region                = data.aws_region.current.name
    account               = data.aws_caller_identity.current.account_id
    athena_database_name  = aws_glue_catalog_database.cur.name
    athena_cur_table_name = var.glue_destination_table
    user_arn              = var.quicksight_user_arn
  })
  filename        = "${path.module}/.generated/${each.key}"
  file_permission = "0600"
}


resource "null_resource" "quicksight_data_sets" {
  for_each = local.quicksight_dataset_template_paths

  triggers = {
    checksum = filesha256(each.key)
  }

  provisioner "local-exec" {
    command = join(" ", [
      "aws quicksight create-data-set",
      "--cli-input-json file://${local_file.quicksight_data_sets[each.key].filename}",
      "--region ${data.aws_region.current.name}",
      "--aws-account-id ${data.aws_caller_identity.current.account_id}",
    ])
  }
}

resource "local_file" "cudos_dashboard" {
  content = templatefile("${path.module}/dashboards/cudos.json", {
    region           = data.aws_region.current.name
    awsAccountId     = data.aws_caller_identity.current.account_id
    sourceAccountId  = var.quicksight_dashboard_source_account_id
    dashboardId      = var.quicksight_cudos_dashboard_id
    sourceTemplateId = var.quicksight_dashboard_cudos_source_template_id
    user_arn         = var.quicksight_user_arn
  })

  filename        = "${path.module}/.generated/dashboards/cudos.json"
  file_permission = "0600"
}

resource "null_resource" "quicksight_dashboard_cudos" {
  triggers = {
    checksum = filesha256("${path.module}/dashboards/cudos.json")
  }

  provisioner "local-exec" {
    command = join(" ", [
      "aws quicksight create-dashboard",
      "--cli-input-json file://${local_file.cudos_dashboard.filename}",
      "--region ${data.aws_region.current.name}",
      "--aws-account-id ${data.aws_caller_identity.current.account_id}",
      "--output table",
    ])
  }
}


