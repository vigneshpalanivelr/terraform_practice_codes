variable "ebs_volume_count"     {}
variable "ebs_device_names"     { type = "list" }
variable "availability_zone"    {}
variable "resource_name"        {}
variable "type"                 {}
variable "tags"                 { type = "map" }
variable "iops"                 {}
variable "encrypted"            {}
