variable "lb_name"                {}
variable "lb_type"                {}
variable "lb_is_internal"         {}
variable "lb_security_group_ids"  {}
variable "subnet_ids"             { type = list(string) }
variable "tags"                   {}