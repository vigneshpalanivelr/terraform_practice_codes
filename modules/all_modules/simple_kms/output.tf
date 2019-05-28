output "cmk_id" {
  value = "${module.test_kms_key_creation_1.cmk_id}"
}

output "cmk_alias" {
  value = "${module.test_kms_key_creation_1.cmk_alias}"
}

output "cmk_arn" {
  value = "${module.test_kms_key_creation_1.cmk_arn}"
}
