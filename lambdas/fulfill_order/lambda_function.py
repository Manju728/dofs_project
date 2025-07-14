import boto3
import os
import json
import random

dynamodb = boto3.resource('dynamodb')
orders_table = dynamodb.Table(os.environ['ORDERS_TABLE'])
failed_table = dynamodb.Table(os.environ['FAILED_ORDERS_TABLE'])
sqs_client = boto3.client('sqs')
queue_url = os.environ['ORDER_QUEUE_URL']

def lambda_handler(event, context):
    failed_item_ids = []
    for record in event['Records']:
        order = json.loads(record['body'])
        order_id = order['order_id']
        if random.random() < 0.7:
            status = 'FULFILLED'
        else:
            status = 'FAILED'
        orders_table.update_item(
            Key={'order_id': order_id},
            UpdateExpression="set #s = :s",
            ExpressionAttributeNames={'#s': 'status'},
            ExpressionAttributeValues={':s': status}
        )
        if status == 'FAILED':
            failed_table.put_item(Item={
                'order_id': order_id,
                'reason': 'Fulfillment failed'
            })
            failed_item_ids.append({"itemIdentifier": record["messageId"]})
        else:
            entries = [{"Id": record["messageId"], "ReceiptHandle": record["receiptHandle"]}]
            if entries:
                sqs_client.delete_message_batch(QueueUrl=queue_url, Entries=entries)
                print("Successfully deleted from the queue")
        print(json.dumps({
            "order_id": order_id,
            "status": status
        }))
        return {"batchItemFailures": failed_item_ids}
