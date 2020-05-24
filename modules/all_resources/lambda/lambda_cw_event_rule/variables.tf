variable "cw_event_rule_name"        {}
variable "cw_event_rule_description" {}
variable "cw_event_rule_schedule_exp"{}
variable "cw_event_rule_is_enabled"  {}
provider "aws"                       { alias = "default" }