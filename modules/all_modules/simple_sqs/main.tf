provider "aws" {
	region	= "${var.aws_region}"
}

module "test_sqs_creation_1" {
	source			= "../../all_resources/sqs_queue"

	resource_creation			= "${var.resource_creation}"
	resource_name				= "${var.resource_name}"

	sqs_fifo_queue				= "${var.sqs_fifo_queue}"
	sqs_visibility_timeout_seconds		= "${var.sqs_visibility_timeout_seconds}"
        sqs_message_retention_seconds       	= "${var.sqs_message_retention_seconds}"
        sqs_max_message_size               	= "${var.sqs_max_message_size}"
        sqs_delay_seconds                   	= "${var.sqs_delay_seconds}"
        sqs_receive_wait_time_seconds		= "${var.sqs_receive_wait_time_seconds}"
        sqs_redrive_policy                  	= "${var.sqs_redrive_policy}"
        sqs_policy                          	= "${var.sqs_policy}"
        sqs_content_based_deduplication     	= "${var.sqs_content_based_deduplication}"
	
	tag_project_code			= "${var.tag_project_code}"
	tag_department				= "${var.tag_department}"
}
