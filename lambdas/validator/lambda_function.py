import json

def lambda_handler(event, context):
    required = ['customer_id', 'items', 'order_id']
    for field in required:
        if field not in event:
            raise Exception(f"Missing field: {field}")
    return event
