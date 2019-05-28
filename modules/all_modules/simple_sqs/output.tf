output "sqs_queue_url" {
  value = "${module.test_sqs_creation_2.sqs_queue_url}"
}
output "sqs_queue_arn" {
  value = "${module.test_sqs_creation_2.sqs_queue_arn}"
}
output "sqs_queue_url_dlq" {
  value = "${module.test_sqs_creation_DLQ.sqs_queue_url}"
}
output "sqs_queue_arn_dlq" {
  value = "${module.test_sqs_creation_DLQ.sqs_queue_arn}"
}
