################################################################################
# Athena workgroups
################################################################################

resource "aws_athena_workgroup" "this" {
  for_each = {
    for k, v in var.workgroups :
    v.name => v if var.create
  }
  name          = each.value.name
  description   = each.value.description
  state         = each.value.enabled ? "ENABLED" : "DISABLED"
  tags          = var.tags
  force_destroy = each.value.force_destroy

  dynamic "configuration" {
    for_each = each.value.configuration != null ? [1] : []
    content {
      bytes_scanned_cutoff_per_query     = each.value.configuration.bytes_scanned_cutoff_per_query
      enforce_workgroup_configuration    = each.value.configuration.enforce_workgroup_configuration
      execution_role                     = each.value.configuration.execution_role
      publish_cloudwatch_metrics_enabled = each.value.configuration.publish_cloudwatch_metrics_enabled
      requester_pays_enabled             = each.value.configuration.requester_pays_enabled
      result_configuration {
        dynamic "encryption_configuration" {
          for_each = each.value.configuration.encryption_configuration != null ? [1] : []
          content {
            encryption_option = each.value.configuration.encryption_configuration.encryption_option
            kms_key_arn       = each.value.configuration.encryption_configuration.kms_key_arn
          }
        }
        dynamic "acl_configuration" {
          for_each = each.value.configuration.s3_acl_option != null ? [1] : []
          content {
            s3_acl_option = each.value.configuration.s3_acl_option
          }
        }
        expected_bucket_owner = each.value.configuration.expected_bucket_owner
        output_location       = each.value.configuration.output_location
      }
      engine_version {
        selected_engine_version = each.value.configuration.selected_engine_version
      }
    }
  }
}

################################################################################
# Athena databases
################################################################################

resource "aws_athena_database" "this" {
  for_each = {
    for k, v in var.databases :
    v.name => v if var.create
  }
  name                  = each.value.name
  bucket                = each.value.bucket
  comment               = each.value.description
  expected_bucket_owner = each.value.expected_bucket_owner
  force_destroy         = each.value.force_destroy
  properties            = each.value.properties

  dynamic "encryption_configuration" {
    for_each = each.value.encryption_enabled ? [1] : []
    content {
      encryption_option = each.value.encryption_option
      kms_key           = each.value.encryption_kms_key
    }
  }

  dynamic "acl_configuration" {
    for_each = each.value.s3_acl_option != null ? [1] : []
    content {
      s3_acl_option = each.value.s3_acl_option
    }
  }
}

################################################################################
# Athena named queries
################################################################################

resource "aws_athena_named_query" "this" {
  for_each = {
    for k, v in var.named_queries :
    v.name => v if var.create
  }
  name        = each.value.name
  database    = try(aws_athena_database.this[each.value.database].id, each.value.database)
  query       = each.value.query
  workgroup   = each.value.workgroup != null ? try(aws_athena_workgroup.this[each.value.workgroup].id, each.value.workgroup) : null
  description = each.value.description
}

################################################################################
# Athena data catalogs
################################################################################
resource "aws_athena_data_catalog" "this" {
  for_each = {
    for k, v in var.data_catalogs :
    v.name => v if var.create
  }
  name        = each.value.name
  type        = each.value.type
  parameters  = each.value.parameters
  description = each.value.description
  tags        = var.tags
}
