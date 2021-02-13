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
    cw_event_rule_schedule_eve = ""
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
    cw_event_rule_schedule_eve = ""
  }
  ec2_volume_eni_checker = {
    lambda_name         = "ec2_volume_eni_checker"
    lambda_handler      = "ec2_volume_eni_checker.volume_eni_checker"
    lambda_runtime      = "python3.7"
    lambda_timeout      = "30"
    lambda_publish      = "false"
    lambda_memory_size  = "128"
    lambda_environment  = { 
      region         = "ap-south-1"
    }
    cw_event_rule_name         = "ec2_volume_eni_checker"
    cw_event_rule_description  = "ec2_volume_eni_checker for every week"
    cw_event_rule_schedule_exp = "rate(7 days)"
    cw_event_rule_schedule_eve = ""
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
    cw_event_rule_schedule_eve = ""
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
    cw_event_rule_schedule_eve = ""
  }
  ec2_instance_profile_checker = {
    lambda_name         = "ec2_instance_profile_checker"
    lambda_handler      = "ec2_instance_profile_checker.check_cloudtrail_events"
    lambda_runtime      = "python3.7"
    lambda_timeout      = "30"
    lambda_publish      = "false"
    lambda_memory_size  = "128"
    lambda_environment  = { 
      region         = "ap-south-1"
    }
    cw_event_rule_name         = "ec2_instance_profile_checker_cw_rule"
    cw_event_rule_description  = "ec2_instance_profile_checker - Every CloudTrail API call - EC2 Instance profile change"
    cw_event_rule_schedule_exp = ""
    cw_event_rule_schedule_eve = "true"
  }
  iam_access_key_checker = {
    lambda_name         = "iam_access_key_checker"
    lambda_handler      = "iam_access_key_checker.check_access_key"
    lambda_runtime      = "python3.7"
    lambda_timeout      = "30"
    lambda_publish      = "false"
    lambda_memory_size  = "128"
    lambda_environment  = { 
      region         = "ap-south-1"
      graceDays      = "1"
      maxDays        = "2"
    }
    cw_event_rule_name         = "iam_access_key_checker_cw_rule"
    cw_event_rule_description  = "iam_access_key_checker at 0 every day night"
    cw_event_rule_schedule_exp = "cron(0/5 * * * ? *)" #"cron(30 18 * * ? *)"
    cw_event_rule_schedule_eve = ""
  }
}