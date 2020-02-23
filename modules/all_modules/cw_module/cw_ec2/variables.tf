variable "aws_region" 			{}
variable "aws_account_num" 		{}
variable "assume_role" 			{}
variable "instance_name" 		{}
variable "sns_topic_information" 	{}
variable "sns_topic_critical" 		{}
variable "cw_cpu_threshold_info" 	{}
variable "cw_cpu_threshold_critical" 	{}
variable "cw_cpu_period" 		{}
variable "cw_mem_threshold_info" 	{}
variable "cw_mem_threshold_critical" 	{}
variable "cw_mem_period" 		{}
variable "cw_diskspc_threshold" 	{}
variable "cw_diskspc_period" 		{}
variable "ebs_devices_list" 		{ type = "list" }
variable "ebs_mount_path_list" 		{ type = "list" }
variable "cw_inst_status_period" 	{}
