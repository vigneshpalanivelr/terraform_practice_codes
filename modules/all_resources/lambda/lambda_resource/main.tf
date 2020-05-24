resource "aws_lambda_function" "lambda" {
  provider  = aws.default
  
  function_name    = var.lambda_name
  handler          = var.lambda_handler
  role             = var.lambda_role_arn
  runtime          = var.lambda_runtime
  timeout          = var.lambda_timeout
  filename         = var.lambda_filename
  source_code_hash = var.lambda_source_code_hash
  
  memory_size      = var.lambda_memory_size
  publish          = var.lambda_publish
  
  vpc_config {
    subnet_ids          = var.lambda_subnets
    security_group_ids  = var.lambda_security_groups
  }
  
  environment {
    variables = var.lambda_env_vars
  }
  
  tags	= "${merge(var.tags, map("Name", var.lambda_name), map("Resource_Name", "Lambda_Function"))}"
}
