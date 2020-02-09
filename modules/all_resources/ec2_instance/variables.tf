variable "ami"					                        {}
variable "availability_zone"			              {}
variable "ec2_instance_name"                    {}
variable "ebs_optimized"			                  {}
variable "disable_api_termination"		          {}
variable "instance_initiated_shutdown_behavior"	{}
variable "instance_type"			                  {}
variable "monitoring"				                    {}
variable "vpc_security_group_ids"		            { type = "list" }
variable "subnet_id"				                    {}
variable "iam_instance_profile"                 {}
variable "tags"					                        { type = "map" }
variable "network_interface_id"                 {}
variable "volume_type"				                  {}
variable "volume_size"				                  {}
variable "iops"					                        {}
variable "delete_on_termination"		            {}
