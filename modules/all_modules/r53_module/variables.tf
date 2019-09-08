variable "aws_region" {}
variable "aws_account_num" {}
variable "assume_role" {}

variable "r53_zone_name" {}
variable "r53_zone_force_destroy" {}
variable "r53_zone_tags" { type = "map" }
variable "vpc_name" {}
