output "sqs_queue_url" {
        value   = "${module.test_sqs_creation_1.sqs_queue_url}"
}

output "sqs_queue_arn" {
        value   = "${module.test_sqs_creation_1.sqs_queue_arn}"
}
