resource "aws_sns_topic" "sns_topic" {
  name         = "${var.topic_name}"
  display_name = "${var.topic_name}"
  tags         = "${merge(var.tags, map("Name", var.topic_name), map("Resource_Name", "SNS_Topic"))}"
  delivery_policy = <<EOF
  {
    "http"	: {
      "defaultHealthyRetryPolicy": {
      "minDelayTarget"		: 20,
      "maxDelayTarget"		: 20,
      "numRetries"			: 3,
      "numMaxDelayRetries"	: 0,
      "numNoDelayRetries"	: 0,
      "numMinDelayRetries"	: 0,
      "backoffFunction"		: "linear"
      },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy"	: {
      "maxReceivesPerSecond": 1
      }
    }
  }
  EOF
  /*
  # This is another way f creation subscription.
  # But, We cannot destroy it.
  # Hence commenting it
  provisioner "local-exec" {
    command = "aws sns subscribe --topic-arn ${aws_sns_topic.sns_topic.arn} --protocol ${var.protocol} --notification-endpoint ${var.endpoint}"
  }
  */
}

data "aws_iam_policy_document" "sns-topic-policy" {
  policy_id = "__default_policy_ID"
  statement {
    effect    = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
	  "SNS:GetTopicAttributes",
	  "SNS:SetTopicAttributes",
	  "SNS:AddPermission",
	  "SNS:RemovePermission",
	  "SNS:DeleteTopic",
	  "SNS:Subscribe",
	  "SNS:ListSubscriptionsByTopic",
	  "SNS:Publish",
	  "SNS:Receive",
	]
	condition {
	  test     = "StringEquals"
	  variable = "AWS:SourceOwner"
	  values   = ["${var.aws_account}",]
	}
	resources = ["${aws_sns_topic.sns_topic.arn}",]
	sid = "__default_statement_ID"
  }
}

resource "aws_sns_topic_policy" "sns_topic_policy" {
  arn    = "${aws_sns_topic.sns_topic.arn}"
  policy = "${data.aws_iam_policy_document.sns-topic-policy.json}"
}

data "template_file" "sns_subscription_template" {
  template = "${file("${path.module}/sns_subscription.tpl")}"
  vars     = {
    topic_name = "${var.topic_name}"
    endpoint   = "${var.endpoint}"
    protocol   = "${var.protocol}"
    topic_arn  = "${aws_sns_topic.sns_topic.id}"
  }
}

resource "aws_cloudformation_stack" "sns_subcription" {
  name          = "${var.topic_name}-${var.protocol}-subscription"
  template_body = "${data.template_file.sns_subscription_template.rendered}"
}
