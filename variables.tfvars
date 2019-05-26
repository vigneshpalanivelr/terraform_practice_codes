aws_region 		= "us-east-2"

resource_creation	= true
resource_name		= "test"

sqs_visibility_timeout_seconds	= 30
sqs_message_retention_seconds	= 345600
sqs_max_message_size		= 262144
sqs_delay_seconds		= 0
sqs_receive_wait_time_seconds	= 0
sqs_redrive_policy              = ""
sqs_policy			= ""
sqs_fifo_queue			= false
sqs_content_based_deduplication	= false

kms_resource_name		= "This_is_a_test_key_creation"
kms_deletion_window_in_days	= 30
kms_enable_key_rotation		= "true"

tag_project_code		= "US-EMEA-APAC"
tag_department			= "Database"
