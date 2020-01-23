variable "aws_region"       {}
variable "aws_account_num"	{}
variable "assume_role"		{}

variable "ebs_availability_zone"	{}
variable "ebs_size"                 {}
variable "ebs_type"                 {}
variable "ebs_tags"                 { type = "map" }
variable "ebs_name"                 {}
variable "ebs_iops"                 {}
variable "ebs_encrypted"            {}
