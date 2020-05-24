resource "aws_cloudwatch_event_target" "event_target" {
  provider = aws.default
  
  rule = var.cw_event_rule
  arn  = var.cw_event_target_arn
}
