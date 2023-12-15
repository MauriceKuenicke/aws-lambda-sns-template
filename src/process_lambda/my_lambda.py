import boto3
import pytest
from my_module import some_function


def lambda_handler(event, context):
    result = "Hello World"
    print(event)
    print(context)
    return {
        'statusCode': 200,
        'body': {
            'from_hanlder': result,
            'from_module': some_function(),
            'debug_event': event
        }
    }
