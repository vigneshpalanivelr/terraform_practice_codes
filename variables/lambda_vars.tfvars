lambda_functions = {
  lambda_ec2_stop_function = {
    lambda_name         = "ec2_stop_scheduler"
    lambda_handler      = "ec2_stop_scheduler.stop_instance"
    lambda_role         = "lambda_deployer_role"
    lambda_runtime      = "python3.7"
    lambda_timeout      = "45"
    lambda_environment  = { 
      region = "ap-south-1"
    }
    cw_event_rule_name         = "ec2_stop_scheduler_cw_rule"
    cw_event_rule_description  = "ec2_stop_scheduler at 0 and 2 every day night"
    cw_event_rule_schedule_exp = "0 0,2 * ? *"
  }
}