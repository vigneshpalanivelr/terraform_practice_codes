{
  "AWSTemplateFormatVersion" : "2010-09-09",
  "Description" : "The SNS ${protocol} subscription for ${topic_name}",
  "Resources" : {
    "SNSSubscription" : {
      "Type" : "AWS::SNS::Subscription",
      "Properties" : {
        "Endpoint" : "${endpoint}",
        "Protocol" : "${protocol}",
        "TopicArn" : "${topic_arn}"
      }
    }
  },
  "Outputs" : {}
}
