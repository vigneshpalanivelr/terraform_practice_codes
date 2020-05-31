az_count         = 3

lambda_role      = "lambda_deployer_role"
lambda_functions = {
  ec2_stop_scheduler = {
    lambda_name         = "ec2_stop_scheduler"
    lambda_handler      = "ec2_stop_scheduler.stop_instance"
    lambda_runtime      = "python3.7"
    lambda_timeout      = "45"
    lambda_publish      = "false"
    lambda_memory_size  = "128"
    lambda_environment  = { 
      region = "ap-south-1"
    }
    cw_event_rule_name         = "ec2_stop_scheduler_cw_rule"
    cw_event_rule_description  = "ec2_stop_scheduler at 0 every day night"
    cw_event_rule_schedule_exp = "cron(30 18 * * ? *)"
  }
  ec2_ss_delete_scheduler = {
    lambda_name         = "ec2_ss_delete_scheduler"
    lambda_handler      = "ec2_ss_delete_scheduler.snapshots_cleanup"
    lambda_runtime      = "python3.7"
    lambda_timeout      = "30"
    lambda_publish      = "false"
    lambda_memory_size  = "128"
    lambda_environment  = { 
      region         = "ap-south-1"
      tolerated_days = "1"
    }
    cw_event_rule_name         = "ec2_ss_delete_scheduler_cw_rule"
    cw_event_rule_description  = "ec2_ss_delete_scheduler at 0 every day night"
    cw_event_rule_schedule_exp = "cron(30 18 * * ? *)"
  }
  rds_stop_scheduler = {
    lambda_name         = "rds_stop_scheduler"
    lambda_handler      = "rds_stop_scheduler.stop_instance"
    lambda_runtime      = "python3.7"
    lambda_timeout      = "45"
    lambda_publish      = "false"
    lambda_memory_size  = "128"
    lambda_environment  = { 
      region = "ap-south-1"
    }
    cw_event_rule_name         = "rds_stop_scheduler_cw_rule"
    cw_event_rule_description  = "rds_stop_scheduler at 0 every day night"
    cw_event_rule_schedule_exp = "cron(30 18 * * ? *)"
  }
  rds_ss_delete_scheduler = {
    lambda_name         = "rds_ss_delete_scheduler"
    lambda_handler      = "rds_ss_delete_scheduler.snapshots_cleanup"
    lambda_runtime      = "python3.7"
    lambda_timeout      = "30"
    lambda_publish      = "false"
    lambda_memory_size  = "128"
    lambda_environment  = { 
      region         = "ap-south-1"
      tolerated_days = "1"
    }
    cw_event_rule_name         = "rds_ss_delete_scheduler_cw_rule"
    cw_event_rule_description  = "rds_ss_delete_scheduler at 0 every day night"
    cw_event_rule_schedule_exp = "cron(30 18 * * ? *)"
  }
}