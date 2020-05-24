data "aws_vpc" "default_vpc" {
  provider = aws.default
  
  filter {
    name  = "tag:Name"
    value = [var.vpc_name]
  }
}

data "aws_subnet" "filter_subnet" {
  provider = aws.default
  
  filter {
    name   = "tag:Name"
    values = [var.vpc_subnet_name]
  }
}

data "aws_security_group" "filter_sg" {
  provider = aws.default
  
  name = "${var.sg_group_name}"
}

data "archive_file" "handler_code" {
  type        = "zip"
  source_file = "${path.module}/handlers/${var.lambda_functions[var.lambda_function]["lambda_name"]}/"
  output_path = "${path.module}/handlers/${var.lambda_functions[var.lambda_function]["lambda_name"]}.zip"
}

module "lambda_scheduler" {
  providers       = { aws.default = aws.default }
  
  source          = "../../all_resources/lambda/lambda_resource/"
  
  lambda_name             = var.lambda_functions[var.lambda_function]["lambda_name"]
  lambda_handler          = var.lambda_functions[var.lambda_function]["lambda_handler"]
  lambda_role_arn         = "arn:aws:iam::${var.aws_account_num}:role/${var.lambda_role}"
  lambda_subnets          = data.aws_subnet.filter_subnet.id
  lambda_security_groups  = [data.aws_security_group.filter_sg.id]
  lambda_runtime          = var.lambda_functions[var.lambda_function]["lambda_runtime"]
  lambda_timeout          = var.lambda_functions[var.lambda_function]["lambda_timeout"]
  lambda_filename         = data.archive_file.handler_code.output_path
  lambda_source_code_hash = filebase64sha256(data.archive_file.handler_code.output_path)
  lambda_env_vars         = var.lambda_functions[var.lambda_function]["lambda_environment"]
  tags                    = var.tags
}

module "lambda_cw_event_rule" {
  providers       = { aws.default = aws.default }
  
  source          = "../../all_resources/lambda/lambda_cw_event_rule/"
  
  cw_event_rule_name         = var.lambda_functions[var.lambda_function]["cw_event_rule_name"]
  cw_event_rule_description  = var.lambda_functions[var.lambda_function]["cw_event_rule_description"]
  cw_event_rule_schedule_exp = var.lambda_functions[var.lambda_function]["cw_event_rule_schedule_exp"]
  cw_event_rule_is_enabled   = "true"
}

module "lambda_permission" {
  providers       = { aws.default = aws.default }
  
  source          = "../../all_resources/lambda/lambda_permission/"
  
  lambda_perm_statement_id  = var.lambda_functions[var.lambda_function]["cw_event_rule_name"]
  lambda_prem_action        = "lambda:InvokeFunction"
  lambda_perm_function_name = module.lambda_scheduler.function_name
  lambda_perm_principal     = "events.amazonaws.com"
  lambda_perm_source_arn    = module.lambda_cw_event_rule.cw_event_rule_arn
}

module "lambda_cw_event_target" {
  providers       = { aws.default = aws.default }
  
  source          = "../../all_resources/lambda/lambda_cw_event_target/"
  
  cw_event_rule       = var.lambda_functions[var.lambda_function]["cw_event_rule_name"]
  cw_event_target_arn = module.lambda_scheduler.arn
}