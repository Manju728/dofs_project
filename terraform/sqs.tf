resource "aws_sqs_queue" "order_dlq" {
  name = "order_dlq"
}

resource "aws_sqs_queue" "order_queue" {
  name = "order_queue"
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.order_dlq.arn
    maxReceiveCount     = 1
  })
}

output "order_queue" {
  value = aws_sqs_queue.order_queue.url
}
output "order_dlq" {
  value = aws_sqs_queue.order_dlq.url
}