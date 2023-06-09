################################################################################
# Athena workgroups
################################################################################

output "workgroups_arns" {
  description = "Map of Athena workgroups ARNs"
  value = try({
    for workgroup in var.workgroups : workgroup.name =>
    aws_athena_workgroup.this[workgroup.name].arn
  }, null)
}

################################################################################
# Athena databases
################################################################################

output "databases_ids" {
  description = "Map of Athena databases IDs"
  value = try({
    for database in var.databases : database.name =>
    aws_athena_database.this[database.name].id
  }, null)
}

################################################################################
# Athena named queries
################################################################################

output "named_queries_ids" {
  description = "Map of Athena named queries IDs"
  value = try({
    for query in var.named_queries : query.name =>
    aws_athena_named_query.this[query.name].id
  }, null)
}

################################################################################
# Athena data catalogs
################################################################################

output "data_catalogs_ids" {
  description = "Map of Athena data catalogs IDs"
  value = try({
    for dat_catalog in var.data_catalogs : dat_catalog.name =>
    aws_athena_data_catalog.this[dat_catalog.name].id
  }, null)
}

output "data_catalogs_arns" {
  description = "Map of Athena data catalogs ARNs"
  value = try({
    for dat_catalog in var.data_catalogs : dat_catalog.name =>
    aws_athena_data_catalog.this[dat_catalog.name].arn
  }, null)
}
