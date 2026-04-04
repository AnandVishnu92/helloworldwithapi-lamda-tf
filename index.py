import json

def lambda_handler(event, context):
    """
    Simple Hello World Lambda function that returns a JSON response
    """
    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        },
        'body': json.dumps({
            'message': 'Hello, World!',
            'description': 'This is a simple API powered by AWS Lambda and API Gateway',
            'request_id': context.request_id
        })
    }
