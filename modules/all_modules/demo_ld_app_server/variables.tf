# Account variables
variable "aws_region"                               {}
variable "aws_account_num"                          {}
variable "assume_role"                              {}

# VPC variables
variable "aws_vpc_name"                             {}
variable "vpc_subnet_name"                          {}

# EC2 instance module variables
variable "ec2_ami_id"                               {}
variable "ec2_instance_name"                        {}
variable "ec2_az"                                   {}
variable "ec2_ebs_optimized"                        {}
variable "ec2_disable_api_termination"              {}
variable "ec2_instance_initiated_shutdown_behavior" {}
variable "ec2_instance_type"                        {}
variable "ec2_monitoring"                           {}
variable "tags"                                     { type = "map"}
variable "ec2_root_volume_type"                     {}
variable "ec2_root_volume_size"                     {}
variable "ec2_root_volume_iops"                     {}
variable "ec2_root_volume_delete_on_termination"    {}

# Userdata template variables
variable "ssh_group"                                {}
variable "sudo_group"                               {}
variable "root_user"                                {}
variable "root_passwd"                              {}