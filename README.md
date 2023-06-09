# AWS Athena Terraform module
Terraform module for AWS Athena resources creation

## Usage

```hcl
module "athena" {
  source  = "data-platform-hq/athena/aws"
  version = "~> 1.0"
  
  tags = {
    ENV : "Development"
  }
  workgroups = [
    {
      name = "workgroup1"
    }
  ]
  databases = [
    {
      name   = "db1"
      bucket = "bucket1"
    }
  ]
  named_queries = [
    {
      name      = "query1"
      database  = "db1"
      query     = "SELECT * db1 limit 10;"
      workgroup = "workgroup1"
    },
    {
      name      = "query2"
      database  = "db_manual"
      query     = "SELECT * db_manual limit 10;"
      workgroup = "workgroup_manual"
    },
    {
      name     = "query3"
      database = "db1"
      query    = "SELECT * db1 limit 10;"
    }
  ]
  data_catalogs = [
    {
      name = "glue-data-catalog"
      type = "GLUE"
      parameters = {
        "catalog-id" = "123456789012"
      }
      description = "Glue based Data Catalog"
    }
  ]

}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name                                                                        | Version  |
|-----------------------------------------------------------------------------|----------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform)   | >= 1.0   |
| <a name="requirement_aws"></a> [aws](#requirement\_aws)                     | >= 5.1.0 |

## Providers

| Name                                                | Version  |
|-----------------------------------------------------|----------|
| <a name="provider_aws"></a> [aws](#provider\_aws)   | >= 5.1.0 |

## Modules

No modules.

## Resources

| Name                                                                                                                            | Type     |
|---------------------------------------------------------------------------------------------------------------------------------|----------|
| [aws_athena_workgroup.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_workgroup)       | resource |
| [aws_athena_database.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_database)         | resource |
| [aws_athena_named_query.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_named_query)   | resource |
| [aws_athena_data_catalog.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_data_catalog) | resource |

## Inputs

| Name                                                                                                                         | Description                                                                     | Type                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | Default | Required |
|------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------|:--------:|
| <a name="input_create"></a> [create](#input\_create)                                                                         | Controls if resources should be created (affects nearly all resources)          | `bool`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | `true`  |    no    |
| <a name="input_tags"></a> [tags](#input\_tags)                                                                               | A map of tags to add to all resources                                           | `map(string)`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | `{}`    |    no    |
| <a name="input_workgroups"></a> [workgroups](#input\_workgroups)                                                             | List of Athena workgroups                                                       | <pre>list(object({<br/>  name          = string<br/>  description   = optional(string)<br/>  enabled       = optional(bool, true)<br/>  force_destroy = optional(bool)<br/>  configuration = optional(object({<br/>    bytes_scanned_cutoff_per_query     = optional(number)<br/>    enforce_workgroup_configuration    = optional(bool, true)<br/>    selected_engine_version            = optional(string, "AUTO")<br/>    execution_role                     = optional(string)<br/>    publish_cloudwatch_metrics_enabled = optional(bool, true)<br/>    encryption_configuration = optional(object({<br/>      encryption_option = string<br/>      kms_key_arn       = optional(string)<br/>    }), null)<br/>    s3_acl_option          = optional(string, null)<br/>    expected_bucket_owner  = optional(string)<br/>    output_location        = optional(string)<br/>    requester_pays_enabled = optional(bool)<br/>  }), null)<br/>}))</pre> | `[]`    |    no    |
| <a name="input_databases"></a> [databases](#input\_databases)                                                                | List of Athena databases                                                        | <pre>list(object({<br/>  bucket                = string<br/>  name                  = string<br/>  s3_acl_option         = optional(string, null)<br/>  description           = optional(string)<br/>  encryption_enabled    = optional(bool, false)<br/>  encryption_option     = optional(string)<br/>  encryption_kms_key    = optional(string)<br/>  expected_bucket_owner = optional(string)<br/>  force_destroy         = optional(bool)<br/>  properties            = optional(map(string))<br/>}))</pre>                                                                                                                                                                                                                                                                                                                                                                                                                                          | `[]`    |    no    |
| <a name="input_named_queries"></a> [named\_queries](#input\_named\_queries)                                                  | List of Athena named queries                                                    | <pre>list(object({<br/>  name        = string<br/>  database    = string<br/>  query       = string<br/>  workgroup   = optional(string)<br/>  description = optional(string)<br/>}))</pre>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | `[]`    |    no    |
| <a name="input_data_catalogs"></a> [data\_catalogs](#input\_data\_catalogs)                                                  | List of Athena data catalogs                                                    | <pre>list(object({<br/>  name        = string<br/>  type        = string<br/>  parameters  = map(string)<br/>  description = string<br/>}))</pre>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | `[]`    |    no    |

## Outputs

| Name                                                                                           | Description                      |
|------------------------------------------------------------------------------------------------|----------------------------------|
| <a name="output_workgroups_arns"></a> [workgroups\_arns](#output\_workgroups\_arns)            | Map of Athena workgroups ARNs    |
| <a name="output_databases_ids"></a> [databases\_ids](#output\_databases\_ids)                  | Map of Athena databases IDs      |
| <a name="output_named_queries_ids"></a> [named\_queries\_ids](#output\_named\_queries\_ids)    | Map of Athena named queries IDs  |
| <a name="output_data_catalogs_ids"></a> [data\_catalogs\_ids](#output\_data\_catalogs\_ids)    | Map of Athena data catalogs IDs  |
| <a name="output_data_catalogs_arns"></a> [data\_catalogs\_arns](#output\_data\_catalogs\_arns) | Map of Athena data catalogs ARNs |
<!-- END_TF_DOCS -->

## License

Apache 2 Licensed. For more information please see [LICENSE](https://github.com/data-platform-hq/terraform-azurerm-linux-web-app/tree/main/LICENSE)
