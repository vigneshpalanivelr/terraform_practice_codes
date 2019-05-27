variable "aws_region"				{}
variable "resource_creation"			{}
variable "resource_name"			{}

variable "sqs_fifo_queue" 			{}
variable "sqs_visibility_timeout_seconds"	{}
variable "sqs_message_retention_seconds"	{}
variable "sqs_max_message_size"			{}
variable "sqs_delay_seconds"			{}
variable "sqs_receive_wait_time_seconds"	{}
variable "sqs_redrive_policy"			{}
variable "sqs_policy"				{}
variable "sqs_content_based_deduplication"	{}

variable "tag_project_code"			{}
variable "tag_department"			{}