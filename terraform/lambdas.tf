resource "aws_lambda_function" "api_handler" {
  function_name = "api_handler"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
  filename      = "${path.module}/../lambdas/api_handler/lambda_function.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambdas/api_handler/lambda_function.zip")
  environment {
    variables = {
      STEP_FUNCTION_ARN = aws_sfn_state_machine.order_orchestrator.arn
    }
  }
}
resource "aws_lambda_function" "validator" {
  function_name = "validator"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
  filename      = "${path.module}/../lambdas/validator/lambda_function.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambdas/validator/lambda_function.zip")
}

resource "aws_lambda_function" "order_storage" {
  function_name = "order_storage"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
  filename      = "${path.module}/../lambdas/order_storage/lambda_function.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambdas/order_storage/lambda_function.zip")
  environment {
    variables = {
      ORDERS_TABLE = aws_dynamodb_table.orders.name
    }
  }
}

# data "external" "api_handler" {
#   program = ["bash", "${path.module}/build.sh", "api_handler", "${path.module}/../../lambdas/api_handler"]
# }

# data "external" "fulfill_order" {
#   program = ["bash", "${path.module}/build.sh", "fulfill_order", "${path.module}/../../lambdas/fulfill_order"]
# }

# data "external" "order_storage" {
#   program = ["bash", "${path.module}/build.sh", "order_storage", "${path.module}/../../lambdas/order_storage"]
# }
# data "external" "validator" {
#   program = ["bash", "${path.module}/build.sh","validator", "${path.module}/../../lambdas/validator"]
# }

resource "aws_lambda_function" "fulfill_order" {
  function_name = "fulfill_order"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
  filename      = "${path.module}/../lambdas/fulfill_order/lambda_function.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambdas/fulfill_order/lambda_function.zip")
  environment {
    variables = {
      ORDER_QUEUE_URL           = aws_sqs_queue.order_queue.url
      ORDERS_TABLE        = aws_dynamodb_table.orders.name
      FAILED_ORDERS_TABLE = aws_dynamodb_table.failed_orders.name
    }
  }
}

resource "aws_lambda_event_source_mapping" "fulfill_order_event" {
  event_source_arn = aws_sqs_queue.order_queue.arn
  function_name    = aws_lambda_function.fulfill_order.arn
  function_response_types = ["ReportBatchItemFailures"]
  batch_size       = 1
  enabled          = true
}

resource "aws_cloudwatch_log_group" "api_handler_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.api_handler.function_name}"
  retention_in_days = 14
}

resource "aws_iam_role_policy_attachment" "lambda_cloudwatch" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_cloudwatch_log_group" "validator_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.validator.function_name}"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "fulfill_order_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.fulfill_order.function_name}"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "order_storage_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.order_storage.function_name}"
  retention_in_days = 14
}
# output "api_handler_lambda" {
#   value = aws_lambda_function.api_handler.arn
# }
# output "validator_lambda" {
#   value = aws_lambda_function.validator.arn
# }
# output "order_storage_lambda" {
#   value = aws_lambda_function.order_storage.arn
# }
# output "fulfill_order_lambda" {
#   value = aws_lambda_function.fulfill_order.arn
# }