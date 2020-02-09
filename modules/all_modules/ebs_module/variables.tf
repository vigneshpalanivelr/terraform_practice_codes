variable "aws_region"       {}
variable "aws_account_num"	{}
variable "assume_role"		{}
variable "tags"             { type = "map" }

variable "ebs_volume_count" {}
variable "ebs_device_names" { type = "list" }
variable "resource_name"    {}
variable "ebs_az"           {}
variable "ebs_type"         {}
variable "ebs_iops"         {}
variable "ebs_encrypted"    {}
