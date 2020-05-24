resource "aws_cloudwatch_event_rule" "event_rule" {
  provider  = aws.default
  
  name                = var.cw_event_rule_name
  description         = var.cw_event_rule_description
  schedule_expression = var.cw_event_rule_schedule_exp
  is_enabled          = var.cw_event_rule_is_enabled
}