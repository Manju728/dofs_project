resource "aws_cloudwatch_metric_alarm" "dlq_depth" {
  alarm_name          = "OrderDLQDepth"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  dimensions = {
    QueueName = aws_sqs_queue.order_dlq.name
  }
  alarm_actions = [aws_sns_topic.dlq_alert.arn]
}

resource "aws_sns_topic" "dlq_alert" {
  name = "dlq_alert"
}