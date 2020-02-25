variable "aws_region"		{}
variable "aws_account_num"	{}
variable "assume_role"		{}

variable "sg_group_name"	{}
variable "port_details"		{ type = "map" }
variable "cidr_block"		{ type = "map" }
