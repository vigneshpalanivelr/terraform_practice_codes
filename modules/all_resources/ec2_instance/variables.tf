variable "count_ec2"                                  {}
variable "ami"                                        {}
variable "availability_zone"                          {}
variable "ec2_instance_name"                          {}
variable "ebs_optimized"                              {}
variable "disable_api_termination"                    {}
variable "instance_initiated_shutdown_behavior"       {}
variable "instance_type"                              {}
variable "monitoring"                                 {}
variable "tags"                                       { type = "map" }
variable "volume_type"                                {}
variable "volume_size"                                {}
variable "iops"                                       {}
variable "delete_on_termination"                      {}
variable "userdata"                                   {}
variable "vpc_security_group_ids"                     { type = "list"}