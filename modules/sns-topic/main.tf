resource "aws_sns_topic" "topic" {
  name = "${var.application}-alarm-topic-${var.environment}"
  delivery_policy = jsonencode({
    "http" : {
      "defaultHealthyRetryPolicy" : {
        "minDelayTarget" : 20,
        "maxDelayTarget" : 20,
        "numRetries" : 3,
        "numMaxDelayRetries" : 0,
        "numNoDelayRetries" : 0,
        "numMinDelayRetries" : 0,
        "backoffFunction" : "linear"
      },
      "disableSubscriptionOverrides" : false,
      "defaultThrottlePolicy" : {
        "maxReceivesPerSecond" : 1
      }
    }
  })
  tags = merge(
    var.tags,
    {
      Name = "${var.application}-alarm-topic-${var.environment}"
    }
  )
}

resource "aws_sns_topic_subscription" "topic_email_subscription" {
  count     = length(var.email_list)
  topic_arn = aws_sns_topic.topic.arn
  protocol  = "email"
  endpoint  = var.email_list[count.index]
}