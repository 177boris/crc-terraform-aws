import json
import boto3 
# import requests



def lambda_handler(event, context):


    dynamodb = boto3.resource('dynamodb')

    count_table = dynamodb.Table('cloud-resume-challenge') 

    """
    Updates the visitor count in the table by using an arithmetic
    operation in the update expression. By specifying an arithmetic operation,
    you can adjust the value in a single request, rather than first getting its
    value and then setting its new value.

    :return: The incremented count.
    """


    try:
        response = count_table.update_item(
        Key={"ID" : "VISITOR_COUNT"},
        UpdateExpression="SET visitor_count = if_not_exists(visitor_count, :start) + :inc",
        ExpressionAttributeValues={
            ":inc": 1,
            ":start": 0,
        },
        ReturnValues="UPDATED_NEW",
        )
    except Exception as e:
        print("Error: " + e)

        raise e



    return {

        # temporarily disable cors for testing purposes => to be fixed in future versions 
        "headers": {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "*",
            "Access-Control-Allow-Headers": "*",
        }, 
        "statusCode": 200
    }
