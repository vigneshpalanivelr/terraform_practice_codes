resource "aws_lambda_permission" "lambda_permission" {
  provider = aws.default
  
  statement_id  = var.lambda_perm_statement_id
  action        = var.lambda_prem_action
  function_name = var.lambda_perm_function_name
  principal     = var.lambda_perm_principal
  source_arn    = var.lambda_perm_source_arn
}
