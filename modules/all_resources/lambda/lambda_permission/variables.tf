variable "lambda_perm_statement_id"  {}
variable "lambda_prem_action"        {}
variable "lambda_perm_function_name" {}
variable "lambda_perm_principal"     {}
variable "lambda_perm_source_arn"    {}
provider "aws"                       { alias = "default" }