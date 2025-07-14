resource "aws_dynamodb_table" "orders" {
  name           = "orders"
  hash_key       = "order_id"
  billing_mode   = "PAY_PER_REQUEST"
  attribute {
    name = "order_id"
    type = "S"
  }
}

resource "aws_dynamodb_table" "failed_orders" {
  name           = "failed_orders"
  hash_key       = "order_id"
  billing_mode   = "PAY_PER_REQUEST"
  attribute {
    name = "order_id"
    type = "S"
  }
}

output "orders_table" {
  value = aws_dynamodb_table.orders.name
}
output "failed_orders_table" {
  value = aws_dynamodb_table.failed_orders.name
}