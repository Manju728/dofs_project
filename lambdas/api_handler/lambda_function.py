import json
import boto3
import os
import uuid

step_fn_arn = os.environ['STEP_FUNCTION_ARN']
sfn = boto3.client('stepfunctions')

def lambda_handler(event, context):
    print(event)
    body = json.loads(event["body"])
    order_id = str(uuid.uuid4())
    body['order_id'] = order_id
    response = sfn.start_execution(
        stateMachineArn=step_fn_arn,
        input=json.dumps(body)
    )
    return {
        "statusCode": 202,
        "body": json.dumps({"message": "Order received", "order_id": order_id})
    }
