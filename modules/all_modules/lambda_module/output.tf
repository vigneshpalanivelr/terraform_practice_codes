output "lambda_arn"              { value = module.lambda_scheduler.lambda_arn}"              }
output "lambda_qualified_arn"    { value = module.lambda_scheduler.lambda_qualified_arn}"    }
output "lambda_version"          { value = module.lambda_scheduler.lambda_version}"          }
output "lambda_source_code_hash" { value = module.lambda_scheduler.lambda_source_code_hash}" }
output "lambda_source_code_size" { value = module.lambda_scheduler.lambda_source_code_size}" }
output "lambda_function_name"    { value = module.lambda_scheduler.lambda_function_name}"    }

output "cw_event_rule_id" 	     { value = module.lambda_cw_event_rule.cw_event_rule_id}"    }
output "cw_event_rule_arn"	     { value = module.lambda_cw_event_rule.cw_event_rule_arn}"   }

output "zip_file_size"	         { value = data.archive_file.handler_code.output_size}"         }
output "zip_file_sha"	         { value = data.archive_file.handler_code.output_sha}"          }
output "zip_file_b64s256"	     { value = data.archive_file.handler_code.output_base64sha256}" }
output "zip_file_md5"	         { value = data.archive_file.handler_code.output_md5}"          }