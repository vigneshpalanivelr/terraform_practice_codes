variable "aws_region"			{}
variable "aws_account_num"		{}
variable "assume_role"			{}
variable "s3_bucket_name"               {}
variable "s3_log_bucket_name"           {}
variable "s3_bucket_acl"                {}
variable "s3_log_bucket_acl"            {}
variable "s3_logging_enabled"           {}
variable "s3_log_bucket_logging_enabled"{}
variable "s3_force_destroy"             {}
variable "s3_versioning"                {}
variable "s3_versioning_mfa_delete"     {}
variable "s3_object_lock_enabled"       {}
variable "s3_sse_algorithm"             {}
variable "s3_algorithms"                {}
variable "s3_tags"			{}
variable "s3_log_bucket_tags"		{}
variable "kms_resource_name"            {}