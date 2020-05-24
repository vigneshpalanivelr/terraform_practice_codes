variable "lambda_name"             {}
variable "lambda_handler"          {}
variable "lambda_role_arn"         {}
variable "lambda_runtime"          {}
variable "lambda_timeout"          {}
variable "lambda_filename"         {}
variable "lambda_source_code_hash" {}
variable "lambda_memory_size"      {}
variable "lambda_publish"          {}
variable "lambda_subnets"          { type = list(string) }
variable "lambda_security_groups"  { type = list(string) }
variable "lambda_env_vars"         {}
variable "tags"                    { type = map(string)  }
provider "aws"                     { alias = "default"   }