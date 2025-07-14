import boto3
import os

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['ORDERS_TABLE'])

def lambda_handler(event, context):
    item = {
        'order_id': event['order_id'],
        'customer_id': event['customer_id'],
        'items': event['items'],
        'status': 'RECEIVED'
    }
    table.put_item(Item=item)
    return event
