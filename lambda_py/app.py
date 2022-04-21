import sys
import base64
import json
def handler(event, context):
    if 'body' in event:
        event_body = base64.b64decode(event["body"]).decode('utf-8')
        print(event_body)
        print(type(event_body))
        event_body_dict = json.loads(event_body)
        name = event_body_dict["name"]
    else:
        name = "no name"

    if "rawQueryString" in event:
        qs = event["rawQueryString"]
    else:
        qs = ""


    return f"Hello {name} from AWS Lambda using Python {sys.version} ! \n query string is {qs}"