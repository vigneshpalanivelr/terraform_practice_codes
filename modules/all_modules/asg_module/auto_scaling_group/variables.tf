variable "asg_name"                   {}
variable "asg_max_size"               {}
variable "asg_min_size"               {}
variable "asg_desired_capacity"       { default = 0   }
# variable "asg_availability_zones"     { type = "list" }
variable "asg_health_check_type"      {}
variable "asg_tags"                   { type = list(map(any)) }
variable "asg_force_delete"           {}