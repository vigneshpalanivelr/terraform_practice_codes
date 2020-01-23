variable "aws_region"		{}
variable "aws_account_num"	{}
variable "assume_role"		{}

variable "eni_subnet"		{}
variable "eni_security_group"	{}
variable "instance_name"	{}
variable "eni_tags"         	{ type = "map" }
