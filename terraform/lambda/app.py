# Python lambda function to handle DB calls from the API Gateway. 

import json, boto3, os, logging
from decimal import Decimal 


def lambda_handler(event, context):

    """ CRC visitor count Lambda handler

    Parameters
    ----------
    event: dict, required
        API Gateway Lambda Proxy Input Format
        Event doc: https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html#api-gateway-simple-proxy-for-lambda-input-format
    context: object, required
        Lambda Context runtime methods and attributes
        Context doc: https://docs.aws.amazon.com/lambda/latest/dg/python-context-object.html
    Returns
    ------
    API Gateway Lambda Proxy Output Format: dict
        Return doc: https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html
    """


    # Initialise logger
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)

    # Get the service resource
    dynamodb = boto3.resource('dynamodb')

    # Define table to be used
    table = dynamodb.Table('visitor-counter-crc')
   
    responseMessage = "Hello! - From crc-dev AWS Lambda." 
    json_region = os.environ['AWS_REGION']


    # Update count value
    try: 
        response = table.update_item(
        Key={
            "ID" : "visitor_count"
        },
        UpdateExpression="SET val = if_not_exists(val, :start) + :inc",
        ExpressionAttributeValues={
            ":inc": 1,
            ":start": 0,
        },
        ReturnValues="UPDATED_NEW",
        )
        responseMessage += " Update successful"
    except Exception as e:
        logging.error("Exception: " + str(e))



    # Get updated count 
    response = table.get_item(
            Key={
                "ID" : "visitor_count"
            },
        )  
    count  = response["Item"]["val"]
    

    response = {
         "statusCode": 200,
          "body": json.dumps({
            "message": responseMessage,
            "Region": json_region,
            "count"  : int(count)
            }),
            "headers": {
              "Content-Type": "application/json",
              'Access-Control-Allow-Headers': 'Content-Type',
              'Access-Control-Allow-Origin': '*',
              'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
          }
    }
    
    return response
