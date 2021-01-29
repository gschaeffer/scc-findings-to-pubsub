import json
from google.cloud import logging


def scc_notification_handler(event, context):
    """Cloud Function to be triggered by PubSub subscription.
       This function receives messages containing SCC Findings data. 
       It creates a log entry within the project allowing Cloud 
       Monitoring to be used for alerting on the SCC findings.

    Args:
        event (dict): The PubSub message payload.
        context (google.cloud.functions.Context): Metadata of triggering event.
    Returns:
        None; the output is written to Cloud Logging.
    """
    import base64

    CUSTOM_LOG_NAME = "scc_notifications_log"
    logging_client = logging.Client()
    logger = logging_client.logger(CUSTOM_LOG_NAME)

    try:
        # PubSub messages come in encrypted
        dataString = base64.b64decode(event['data']).decode('utf-8')
    except Exception as e:
        dataString = "error decoding payload"

    data = dataString
    try:
        # is valid json?
        data = json.loads(dataString)
    except Exception as e:
        # nope
        data = dataString

    logger.log_struct(
        {
            "event_id": context.event_id,
            "timestamp": context.timestamp,
            "data": data,
        }
    )