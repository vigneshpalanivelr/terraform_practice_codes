# VPC Details
vpc_subnet_group				= "default"

# S3 Backend Configuration
aws_region                      = "ap-south-1"
aws_iam_user                    = "deployer"
assume_role                     = "deployer_role"

# R53 Details
r53_zone_name                   = "vignesh-private.zone.com"
r53_record_ttl                  = "300"
r53_zone_force_destroy          = true

# Common Tags
tags = {
  Owner = "Vignesh Palanivel"
  DL    = "Vignesh_Palanivel@aws.com"
  Team  = "terraform-services-india"
  CCPC  = "123456789"
}

# SNS Topics
sns_topic_information		    = "test-sns-topic-information-alert"
sns_topic_critical		        = "test-sns-topic-critical-alert"

resource_creation               = true
sqs_resource_name               = "main-sqs-queue"
sqs_visibility_timeout_seconds  = 30
sqs_message_retention_seconds   = 345600
sqs_max_message_size            = 262144
sqs_delay_seconds               = 0
sqs_receive_wait_time_seconds   = 0
sqs_redrive_policy              = ""
sqs_policy                      = ""
sqs_fifo_queue                  = false
sqs_content_based_deduplication = false
kms_key_state_prefix            = "kms_module"
eni_key_state_prefix            = "eni_module"
kms_key_alias_name              = "custome-key"
tag_project_code                = "US-EMEA-APAC"
tag_department                  = "Database"
