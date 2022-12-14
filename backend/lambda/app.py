# Python lambda function to handle DB calls from the API Gateway. 

import json, boto3, os, logging



logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):

    # Get the service resource
    dynamodb = boto3.resource('dynamodb')

    # Define table to be used
    table = dynamodb.Table('visitor-counter-crc')
    
    responseMessage = "Hello AWS Lambda! From crc-dev" 
    json_region = os.environ['AWS_REGION']


    """
    print("Response is: ", response)
    item = response['Item']
    print("\n")
    print("Item is:", item)
    print("\n")
    count = item['record_count']
    print("Count is currently: ", count)
    print("\n")
    """


    # TODO implement count retrieval then increment and update DB 

    count = 0 

    try:
        count = table.get_item(
            Key={"ID" : "visitor_count"},
        )  
    except Exception as e:
        logging.info("## Encountered an error: " + str(e))
        responseMessage = 'Error: ' + str(e)
        print("Setting count to 1.1")
        logging.info("setting count to 717")
        count = 717


    # About event parameter: 
    # name = event['QueryStringParameters']['name'] # or if we're not sure if name is present:
    # name = event.get('QueryStringParameters',{}).get('name','n/a')


    if event["queryStringParameters"] and event["queryStringParameters"]["Name"]: 
        responseMessage += '  ...Hello, ' + event["queryStringParameters"]["Name"] + '! ' 
    elif event["queryStringParameters"] and event["queryStringParameters"]["Counting"]:
        responseMessage += 'Count is: ' + count + " " + event["queryStringParameters"]["Counting"] + '!'  


    # update count 
    """
    Key={"ID" : "visitor_count"},
        UpdateExpression="SET value = if_not_exists(record_count, :start) + :inc",
        ExpressionAttributeValues={
            ":inc": 1,
            ":start": 0,
        },
        ReturnValues="UPDATED_NEW",
        )
    """

    # responseMessage = updated count 
    # count = count value 

    response = {
         "statusCode": 200,
          "body": json.dumps({
            "message": responseMessage,
            "count"  : count,
            "Region": json_region
            }),
            "headers": {
              "Content-Type": "application/json",
              "Access-Control-Allow-Origin": "*"
          },
                #TODO return => "body" : count
    }
    
    return response


