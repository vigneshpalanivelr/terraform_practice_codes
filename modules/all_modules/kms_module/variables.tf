variable "aws_account_num"              {}
variable "aws_region"                   {}
variable "assume_role"                  {}
variable "aws_iam_user"                 {}

variable "kms_key_name"                 {}
variable "kms_is_enabled"               {}
variable "kms_deletion_window_in_days"  {}
variable "kms_enable_key_rotation"      {}
variable "kms_key_tags"                 { type = "map" }
