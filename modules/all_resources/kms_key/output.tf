output "cmk_arn" {
  value = "${aws_kms_key.kms_key_creation_1.arn}"
}

output "cmk_alias" {
  value = "${aws_kms_alias.kms_key_creation_1_alias.arn}"
}

output "cmk_id" {
  value = "${aws_kms_key.kms_key_creation_1.key_id}"
}
