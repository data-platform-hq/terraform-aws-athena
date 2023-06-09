variable "create" {
  description = "Controls if resources should be created (affects nearly all resources)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# Athena workgroups
################################################################################
variable "workgroups" {
  description = "List of Athena workgroups"
  type = list(object({
    name          = string                                          # Name of the workgroup
    description   = optional(string)                                # Description of the workgroup
    enabled       = optional(bool, true)                            # State of the workgroup
    force_destroy = optional(bool)                                  # Option to delete the workgroup and its contents even if the workgroup contains any named queries
    configuration = optional(object({                               # Configuration block with various settings for the workgroup
      bytes_scanned_cutoff_per_query     = optional(number)         # Integer for the upper data usage limit (cutoff) for the amount of bytes a single query in a workgroup is allowed to scan
      enforce_workgroup_configuration    = optional(bool, true)     # Boolean whether the settings for the workgroup override client-side settings
      selected_engine_version            = optional(string, "AUTO") # Requested engine version
      execution_role                     = optional(string)         # Role used in a notebook session for accessing the user's resources
      publish_cloudwatch_metrics_enabled = optional(bool, true)     # Boolean whether Amazon CloudWatch metrics are enabled for the workgroup
      encryption_configuration = optional(object({
        encryption_option = string           # Whether Amazon S3 server-side encryption with Amazon S3-managed keys (SSE_S3), server-side encryption with KMS-managed keys (SSE_KMS), or client-side encryption with KMS-managed keys (CSE_KMS) is used
        kms_key_arn       = optional(string) # For SSE_KMS and CSE_KMS, this is the KMS key ARN
      }), null)
      s3_acl_option          = optional(string, null) # Amazon S3 canned ACL that Athena should specify when storing query results. Valid value is BUCKET_OWNER_FULL_CONTROL
      expected_bucket_owner  = optional(string)       # AWS account ID that you expect to be the owner of the Amazon S3 bucket
      output_location        = optional(string)       # Location in Amazon S3 where your query results are stored, such as s3://path/to/query/bucket/
      requester_pays_enabled = optional(bool)         # If set to true , allows members assigned to a workgroup to reference Amazon S3 Requester Pays buckets in queries
    }), null)
  }))
  default = []
}

################################################################################
# Athena databases
################################################################################

variable "databases" {
  description = "List of Athena databases"
  type = list(object({
    bucket                = string                 # Name of S3 bucket to save the results of the query execution
    name                  = string                 # Name of the database to create
    s3_acl_option         = optional(string, null) # Amazon S3 canned ACL that Athena should specify when storing query results. Valid value is BUCKET_OWNER_FULL_CONTROL
    description           = optional(string)       # Description of the database
    encryption_enabled    = optional(bool, false)  # Whether the encryption is enabled
    encryption_option     = optional(string)       # Type of key; one of SSE_S3, SSE_KMS, CSE_KMS (Required when encryption is enabled)
    encryption_kms_key    = optional(string)       # KMS key ARN or ID; required for key types SSE_KMS and CSE_KMS
    expected_bucket_owner = optional(string)       # AWS account ID that you expect to be the owner of the Amazon S3 bucket
    force_destroy         = optional(bool)         # Boolean that indicates all tables should be deleted from the database so that the database can be destroyed without error
    properties            = optional(map(string))  # Key-value map of custom metadata properties for the database definition
  }))
  default = []
}

################################################################################
# Athena named queries
################################################################################

variable "named_queries" {
  description = "List of Athena named queries"
  type = list(object({
    name        = string           # Plain language name for the query. Maximum length of 128
    database    = string           # Database to which the query belongs
    query       = string           # Text of the query itself. In other words, all query statements. Maximum length of 262144
    workgroup   = optional(string) # Workgroup to which the query belongs
    description = optional(string) # Brief explanation of the query. Maximum length of 1024
  }))
  default = []
}

################################################################################
# Athena data catalogs
################################################################################

variable "data_catalogs" {
  description = "List of Athena data catalogs"
  type = list(object({
    name        = string      # Name of the data catalog
    type        = string      # Type of data catalog: LAMBDA for a federated catalog, GLUE for AWS Glue Catalog, or HIVE for an external hive metastore
    parameters  = map(string) # Key value pairs that specifies the Lambda function or functions to use for the data catalog
    description = string      # Description of the data catalog
  }))
  default = []
}
