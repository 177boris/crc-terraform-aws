from get_function import *

import unittest 
import boto3 
import botocore 
from moto import mock_dynamodb


@mock_dynamodb
class TestGetScript(unittest.TestCase): 


    def setUp(self): 

        self.dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
        self.count_table = self.dynamodb.create_table(
            TableName='cloud-resume-challenge',
            KeySchema=[
                {
                    'AttributeName': 'ID',
                    'KeyType': 'HASH'
                }
            ],
            AttributeDefinitions=[
                {
                    'AttributeName': 'ID',
                    'AttributeType': 'S'
                }
            ],
            ProvisionedThroughput={
                'ReadCapacityUnits': 5,
                'WriteCapacityUnits': 5
            }
        )

        self.count_table.put_item(
            Item={
                'ID': 'VISITOR_COUNT',
                'visitor_count': 0
            }
        )

    def test_get_script(self):
        event = {}
        context = {}
        response = lambda_handler(event, context)

        self.assertEqual(response['statusCode'], 200)
        self.assertEqual(response["body"], '{"count": "\\"0\\""}')


if __name__ == '__main__':
    unittest.main() 
