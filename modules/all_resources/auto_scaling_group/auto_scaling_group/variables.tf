variable "asg_name"                   {}
variable "asg_max_size"               {}
variable "asg_min_size"               {}
# variable "asg_availability_zones"     { type = "list" }
variable "asg_launch_template"        {}
variable "asg_health_check_type"      {}
variable "asg_desired_capacity"       {}
variable "asg_termination_policies"   {}
variable "asg_tags"                   { type = "map"  }
variable "asg_force_delete"           {}