import os
import requests
import json
import argparse
import sys
import logging


# Set argument parser
parser = argparse.ArgumentParser(
    description="Send a message to a Webex room")
parser.add_argument(
    "--room-id", help="Room ID (required)", required=True)
parser.add_argument(
    "--token", help="Webex Authentication Token (required)", required=True)
parser.add_argument(
    "--markdown-msg", help="Message in markdown format (optional)", required=False)
parser.add_argument(
    "--text-msg", help="Message in plain text (optional)", required=False)
parser.add_argument(
    "--loglevel", help="logging level (optional, default is WARNING)", choices=["CRITICAL", "ERROR", "WARNING", "INFO", "DEBUG"], default="WARNING")
args = parser.parse_args()

# Set logging
rootLogger = logging.getLogger()
rootLogger.setLevel(args.loglevel)

# Build payload
api_payload = {
    "roomId":  args.room_id,
    "text": args.text_msg,
    "markdown": args.markdown_msg
}

# Send notification
api_headers = {'Authorization': 'Bearer ' +
               args.token, 'Content-Type': 'application/json'}

resp = requests.post("https://webexapis.com/v1/messages",
                     data=json.dumps(api_payload), headers=api_headers)

logging.debug("Response is: {}".format(resp.json()))

if resp.status_code != 200:
    logging.error("Sending message failed")
    sys.exit(-1)
else:
    logging.info("Message sent succesfully")
    sys.exit(0)
