output "cmk_arn" {
  value = "${aws_kms_key.kms_key_creation.arn}"
}

output "cmk_alias" {
  value = "${aws_kms_alias.kms_key_creation_alias.arn}"
}

output "cmk_id" {
  value = "${aws_kms_key.kms_key_creation.key_id}"
}
