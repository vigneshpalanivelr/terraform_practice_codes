output "cmk_id" {
  value = "${module.kms_key_creation.cmk_id}"
}

output "cmk_alias" {
  value = "${module.kms_key_creation.cmk_alias}"
}

output "cmk_arn" {
  value = "${module.kms_key_creation.cmk_arn}"
}
