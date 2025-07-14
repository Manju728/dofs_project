resource "aws_sfn_state_machine" "order_orchestrator" {
  name     = "order_orchestrator"
  role_arn = aws_iam_role.step_function_exec.arn
  definition = jsonencode({
    StartAt: "ValidateOrder",
    States: {
      ValidateOrder: {
        Type: "Task",
        Resource: aws_lambda_function.validator.arn,
        Next: "StoreOrder"
      },
      StoreOrder: {
        Type: "Task",
        Resource: aws_lambda_function.order_storage.arn,
        Next: "SendToQueue"
      },
      SendToQueue: {
        Type: "Task",
        Resource: "arn:aws:states:::sqs:sendMessage",
        Parameters: {
          QueueUrl: aws_sqs_queue.order_queue.url,
          "MessageBody.$": "$"
        },
        End: true
      }
    }
  })
}