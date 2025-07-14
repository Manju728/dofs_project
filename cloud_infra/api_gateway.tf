resource "aws_api_gateway_rest_api" "orders_api" {
  name = "orders_api"
}

resource "aws_api_gateway_resource" "order" {
  rest_api_id = aws_api_gateway_rest_api.orders_api.id
  parent_id   = aws_api_gateway_rest_api.orders_api.root_resource_id
  path_part   = "order"
}

resource "aws_api_gateway_method" "post_order" {
  rest_api_id   = aws_api_gateway_rest_api.orders_api.id
  resource_id   = aws_api_gateway_resource.order.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.orders_api.id
  resource_id = aws_api_gateway_resource.order.id
  http_method = aws_api_gateway_method.post_order.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.api_handler.arn}/invocations"
}

resource "aws_lambda_permission" "apigw_lambda" {
  action              = "lambda:InvokeFunction"
  function_name       = aws_lambda_function.api_handler.function_name
  principal           = "apigateway.amazonaws.com"
 
  source_arn = "${aws_api_gateway_rest_api.orders_api.execution_arn}/*/POST/order"
  statement_id       = "AllowExecutionFromAPIGateway"
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [aws_api_gateway_integration.lambda]
  rest_api_id = aws_api_gateway_rest_api.orders_api.id
}

resource "aws_api_gateway_stage" "dev" {
  stage_name    = "dev"
  rest_api_id   = aws_api_gateway_rest_api.orders_api.id
  deployment_id = aws_api_gateway_deployment.deployment.id
}

output "api_url" {
  value = "${aws_api_gateway_stage.dev.invoke_url}/order"
}

output "order_api_invoke_url" {
  value =  "${aws_api_gateway_rest_api.orders_api.execution_arn}/*/POST/order"

}