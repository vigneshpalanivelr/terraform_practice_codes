variable "asg_lt_name"                      {}
variable "asg_lt_disable_api_termination"   {}
variable "asg_lt_ami_id"                    {}
variable "asg_lt_instance_type"             {}
variable "asg_lt_sg_ids"                    { type = "list" }
variable "asg_lt_user_data"                 {}
variable "asg_lt_ebs_additional_volumes"    { type = list(map(any)) }
variable "asg_lt_delete_on_termination"     {}
variable "asg_lt_ec2_instance_profile"      {}
variable "asg_lt_associate_public_ip"       {}
variable "tags"                             { type = "map"  }
variable "asg_lt_update_default_version"    {default = true }