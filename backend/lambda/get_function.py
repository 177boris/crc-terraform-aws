import json
import boto3 
from decimal import Decimal

# import requests

class DecimalEncoder(json.JSONEncoder):
  def default(self, obj):
    if isinstance(obj, Decimal):
      return str(obj)
    return json.JSONEncoder.default(self, obj)


def lambda_handler(event, context):
    

    dynamodb = boto3.resource('dynamodb')
    count_table = dynamodb.Table('cloud-resume-challenge') 


    try:
        response = count_table.get_item(
            Key={"ID" : "VISITOR_COUNT"},
        )  
    except Exception as e:
        print("Error: " + e)

        raise e 

    count_value = response['Item']['visitor_count']

    # try:
    #     ip = requests.get("http://checkip.amazonaws.com/")
    # except requests.RequestException as e:
    #     # Send some context about this error to Lambda Logs
    #     print(e)

    #     raise e
    

    return {

        # temporarily disable cors for testing purposes => to be fixed in future versions 
        "headers": {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "*",
            "Access-Control-Allow-Headers": "*",
        }, 
        "statusCode": 200,
        "body": json.dumps({
            "count" : json.dumps(count_value, cls=DecimalEncoder),
            # "location": ip.text.replace("\n", "")
        }),
        
    }
    