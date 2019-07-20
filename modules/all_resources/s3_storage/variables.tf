variable "aws_region"			{}
variable "bucket_name"			{ type = "list" }
variable "log_bucket_name"		{}
variable "bucket_acl"			{}
variable "logging_enabled"		{}
variable "tags"				{}
variable "force_destroy"		{}
variable "versioning"			{}
variable "object_lock_enabled"		{}
variable "mfa_delete"			{}
variable "sse_algorithm"		{}
variable "s3_algorithms"		{}
variable "kms_master_key_id"		{}
