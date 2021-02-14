variable "aws_vpc_name"                     {}
variable "asg_lt_name"                      {}
variable "asg_lt_disable_api_termination"   {}
variable "asg_lt_instance_type"             {}
# variable "asg_lt_shutdown_behaviour"        {}
variable "asg_lt_associate_public_ip"       {}
variable "asg_lt_ebs_additional_volumes"    { type = list(map(any)) }
variable "tags"                             { type = "map" }
variable "asg_lt_delete_on_termination"     {}

variable "asg_lt_sg_name"                   {}
variable "ec2_instance_profile_name"        {}
variable "ami_owner_id"                     {}
variable "ami_regex"                        {}
variable "ami_root_device_type"             {}
variable "ami_virtualization_type"          {}
variable "ssh_group"                        {}
variable "sudo_group"                       {}
variable "root_user"                        {}
variable "root_passwd"                      {}