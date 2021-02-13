variable "aws_region"           {}
variable "aws_account_num"      {}
variable "assume_role"	        {}

variable "resource_name"        {}
variable "ebs_volume_count"     {} 
variable "ebs_device_names"     { type = "list" }
variable "ebs_az"               {}
variable "ebs_type"             {}
variable "s3_backend_bucket"    {}
variable "ebs_key_state_prefix" {}