import json
import datetime

def lambda_handler(event, context):
    """
    Fonction Lambda simple qui renvoie un message Hello World
    """
    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json'
        },
        'body': json.dumps({
            'message': 'Hello World from Lambda!',
            'timestamp': datetime.datetime.now().isoformat(),
            'path': event.get('path', '/'),
            'method': event.get('httpMethod', 'GET')
        })
    }
