# Create lambda function handler resource 

resource "local_file" "app_handler_py" {
  filename = "app.py"
  depends_on = [
    aws_dynamodb_table.counter_table
  ]

  content = <<-EOF

import json, boto3, os, logging
from decimal import Decimal 

# Initialise logger
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Get the service resource
dynamodb = boto3.resource('dynamodb')

TableName = "${aws_dynamodb_table.counter_table.id}"


def lambda_handler(event, context):

    """ CRC visitor count Lambda handler

    # Define table to be used
    table = dynamodb.Table(TableName)
   
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

    EOF
}

