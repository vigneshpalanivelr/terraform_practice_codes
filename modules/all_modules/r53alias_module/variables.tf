variable "aws_region"          {}
variable "aws_account_num"     {}
variable "assume_role"         {}

variable "r53_zone_name"       {}
variable "r53_record_name"     {}
variable "alias_for"           {}
variable "lb_name"             { default = "" }
variable "rds_instance_name"   { default = "" }
variable "r53_record_type"     {}
variable "r53_overwrite"       {}