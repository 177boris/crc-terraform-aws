# Python lambda function to handle API calls from the API Gateway. 
# 
#  

def lambda_handler(event, context):
    message = 'Hello {} {}!'.format(event['first_name'], event['last_name'])  
    return { 
        'message' : message
    }