import json


def lambda_handler(event, context):
    print("Cloud Operations automation triggered")

    print(json.dumps(event))

    for record in event.get("Records", []):
        message = record["Sns"]["Message"]
        print("SNS message:")
        print(message)

    return {
        "statusCode": 200,
        "body": "Cloud Operations alert processed successfully"
    }