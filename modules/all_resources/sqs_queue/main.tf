resource "aws_sqs_queue" "terraform_queue" {
  #     count           = "${var.resource_creation}"
  name                        = "${var.resource_name}"
  fifo_queue                  = "${var.sqs_fifo_queue}"
  visibility_timeout_seconds  = "${var.sqs_visibility_timeout_seconds}"
  message_retention_seconds   = "${var.sqs_message_retention_seconds}"
  max_message_size            = "${var.sqs_max_message_size}"
  delay_seconds               = "${var.sqs_delay_seconds}"
  receive_wait_time_seconds   = "${var.sqs_receive_wait_time_seconds}"
  redrive_policy              = "${var.sqs_redrive_policy}"
  policy                      = "${var.sqs_policy}"
  content_based_deduplication = "${var.sqs_content_based_deduplication}"
  tags = {
    Name       = "${var.resource_name}"
    Project    = "${var.tag_project_code}"
    Department = "${var.tag_department}"
  }
}

resource "aws_sqs_queue_policy" "terraform_queue_policy" {
  #	count		= "${var.resource_creation}"
  queue_url = "${aws_sqs_queue.terraform_queue.id}"
  policy    = <<POLICY
	{
	"Id": "Something_0",
	"Version": "2012-10-17",
	"Statement": [
		{
		"Sid": "Something_1",
		"Action": "sqs:*",
		"Effect": "Allow",
		"Resource": "${aws_sqs_queue.terraform_queue.arn}",
		"Principal": "*"
	}
	]
}
POLICY
}
