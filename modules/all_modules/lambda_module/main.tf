data "aws_vpc" "default_vpc" {
  provider = aws.default
  
  filter {
    name   = "tag:Name"
    values = [var.aws_vpc_name]
  }
}

data "aws_subnet" "filter_subnet" {
  provider = aws.default
  
  count    = var.az_count
  filter {
    name   = "tag:Name"
    values = ["default-subnet-${count.index + 1}"]
  }
}

data "aws_security_group" "filter_sg" {
  provider = aws.default
  
  name = var.sg_group_name
}

/*
##### Type:1 If one single folder needs to be ziped (Working code)
data "archive_file" "handler_code" {
  type        = "zip"
  source_dir  = "${path.module}/handlers/${var.lambda_functions[var.lambda_function]["lambda_name"]}/"
  output_path = "${path.module}/handlers/${var.lambda_functions[var.lambda_function]["lambda_name"]}.zip"
}

##### Type:2 Tried using two directory zip using terraform script(Not Working)
resource "template_dir" "pySetenv" {
  source_dir      = "${path.module}/handlers/pySetenv/"
  destination_dir = "${path.module}/pySetenv"
}

resource "template_dir" "lambda_function" {
  source_dir      = "${path.module}/handlers/${var.lambda_functions[var.lambda_function]["lambda_name"]}/"
  destination_dir = "${path.module}/${var.lambda_functions[var.lambda_function]["lambda_name"]}"
}

data "archive_file" "handler_code" {
  type        = "zip"
  output_path = "${path.module}/handlers/${var.lambda_functions[var.lambda_function]["lambda_name"]}.zip"

  source {
    filename = "pySetenv"
    content  = template_dir.pySetenv.destination_dir
  }

  source {
    filename = "lambda_function"
    content  = template_dir.lambda_function.destination_dir
  }
}

##### Type:3 Tried using two directory zip using shell script(Not Working)
data "external" "make_zip_sh" {
  program = ["bash", "${path.module}/make_zip.sh"]
  query   = {
    module_path = path.module
    lambda      = var.lambda_functions[var.lambda_function]["lambda_name"]
  }
}
*/

data "external" "make_zip_sh" {
  program = ["python", "${path.module}/make_zip.py"]
  query   = {
    main_script   = "${path.module}/handlers/${var.lambda_functions[var.lambda_function]["lambda_name"]}"
    module_script = "${path.module}/handlers/pySetenv"
    main_target   = "${path.module}/${var.lambda_functions[var.lambda_function]["lambda_name"]}"
    module_target = "${path.module}/${var.lambda_functions[var.lambda_function]["lambda_name"]}/pySetenv"
  }
}

data "template_file" "events" {
  count    = var.lambda_functions[var.lambda_function]["cw_event_rule_schedule_exp"] == "" ? 1 : 0
  template = "${file("${path.module}/events/${var.lambda_functions[var.lambda_function]["lambda_name"]}.tpl")}"
}

module "lambda_scheduler" {
  providers       = { aws.default = aws.default }
  
  source          = "../../all_resources/lambda/lambda_resource/"
  
  lambda_name             = var.lambda_functions[var.lambda_function]["lambda_name"]
  lambda_handler          = var.lambda_functions[var.lambda_function]["lambda_handler"]
  lambda_role_arn         = "arn:aws:iam::${var.aws_account_num}:role/${var.lambda_role}"
  lambda_subnets          = data.aws_subnet.filter_subnet.*.id
  lambda_security_groups  = [data.aws_security_group.filter_sg.id]
  lambda_runtime          = var.lambda_functions[var.lambda_function]["lambda_runtime"]
  lambda_timeout          = var.lambda_functions[var.lambda_function]["lambda_timeout"]
  lambda_filename         = "${path.module}/${var.lambda_functions[var.lambda_function]["lambda_name"]}.zip"
  lambda_source_code_hash = filebase64sha256(data.external.make_zip_sh.result["zip_file"])
  lambda_memory_size      = var.lambda_functions[var.lambda_function]["lambda_memory_size"]
  lambda_publish          = var.lambda_functions[var.lambda_function]["lambda_publish"]
  lambda_env_vars         = var.lambda_functions[var.lambda_function]["lambda_environment"]
  tags                    = var.tags
}

module "lambda_cw_event_rule" {
  providers       = { aws.default = aws.default }
  
  source          = "../../all_resources/lambda/lambda_cw_event_rule/"
  
  cw_event_rule_name         = var.lambda_functions[var.lambda_function]["cw_event_rule_name"]
  cw_event_rule_description  = var.lambda_functions[var.lambda_function]["cw_event_rule_description"]
  cw_event_rule_schedule_exp = var.lambda_functions[var.lambda_function]["cw_event_rule_schedule_exp"] == "" ? "" : var.lambda_functions[var.lambda_function]["cw_event_rule_schedule_exp"]
  cw_event_rule_schedule_eve = var.lambda_functions[var.lambda_function]["cw_event_rule_schedule_eve"] == "" ? "" : data.template_file.events.0.rendered
  cw_event_rule_is_enabled   = "true"
}

module "lambda_permission" {
  providers       = { aws.default = aws.default }
  
  source          = "../../all_resources/lambda/lambda_permission/"
  
  lambda_perm_statement_id  = var.lambda_functions[var.lambda_function]["cw_event_rule_name"]
  lambda_prem_action        = "lambda:InvokeFunction"
  lambda_perm_function_name = module.lambda_scheduler.lambda_function_name
  lambda_perm_principal     = "events.amazonaws.com"
  lambda_perm_source_arn    = module.lambda_cw_event_rule.cw_event_rule_arn
}

module "lambda_cw_event_target" {
  providers       = { aws.default = aws.default }
  
  source          = "../../all_resources/lambda/lambda_cw_event_target/"
  
  cw_event_rule       = var.lambda_functions[var.lambda_function]["cw_event_rule_name"]
  cw_event_target_arn = module.lambda_scheduler.lambda_arn
}