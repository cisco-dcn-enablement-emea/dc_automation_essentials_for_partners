import os
import logging
from libs import ndfc
from webexteamssdk import WebexTeamsAPI

# Configure logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)-8s [%(filename)s:%(lineno)d] %(message)s")

# Define API key and username for NDFC access
api_key = {"api_key": f"{os.getenv('NDFC_CLUSTER_3_ADMIN_API_KEY')}", "username": "admin"}

# Define whether to use aggressive sync checking
aggressive = False

# Define a list of fabrics to include from the sync check
include_fabrics = ["mil-cml-core"]

def send_webex_message(message):
    # Retrieve the Webex Teams access token from environment variable
    webex_token = os.environ.get("WEBEX_TEAMS_ACCESS_TOKEN")
    
    # Retrieve the Webex Teams room ID from environment variable
    webex_room_id = os.environ.get("WEBEX_TEAMS_ROOM_ID")
    
    # Establish connection to Webex Teams API
    webex_connection = WebexTeamsAPI(webex_token)
    
    # Send message to Webex Teams room and return success status
    if webex_connection.messages.create(roomId=webex_room_id, text=f"\n{message}\n"):
        return True
    else:
        return False

def main():
    # Create a new NDFC object to interact with network fabrics
    ndfc_obj = ndfc.Ndfc("10.58.31.9", api_key=api_key)

    # Retrieve all fabrics and filter out specific types
    fabrics = [fabric['fabricName'] for fabric in ndfc_obj.get_all_fabrics() if (fabric['templateFabricType'] != "VXLAN EVPN Multi-Site" and include_fabrics==[] or fabric['fabricName'] in include_fabrics)]
    
    # Log the number of fabrics found
    logging.info(f"Found {len(fabrics)} fabrics")
    
    # Iterate over each fabric
    for fabric in fabrics:
        # Retrieve all devices within the fabric
        devices = ndfc_obj.get_all_nodes_by_fabric(fabric)
        
        # Log the number of devices found
        logging.info(f"Found {len(devices)} devices in Fabric {fabric}")

        if aggressive:
            # Compile a list of device serial numbers for aggressive sync
            serials = ",".join([device['serialNumber'] for device in devices])
            
            # Trigger a full sync on the devices, checking for the latest configurations
            report = ndfc_obj.force_calculate_device_diff(fabric, serials)
            
            # Skip unmanaged fabrics with no report
            if not report:
                continue
            
            # Process each device in the sync report
            for device in report:
                if device['pendingConfig']:
                    # Log devices that are not in sync
                    logging.info(f"Device {device['switchName']} in Fabric {fabric} is not in sync")
                    
                    # Compile the list of missing commands into a message
                    commands = "\n".join(device['pendingConfig'])
                    
                    # Send a message to the Webex Teams room
                    send_webex_message(f"The device {device['switchName']} in Fabric {fabric} is not in sync. \n\n {commands}")
        else:
            # Process each device individually for non-aggressive checking
            for device in devices:
                # Check if the device is not in sync
                if device['hostName'] and not device['ccStatus'] == "In-Sync":
                    logging.info(f"Device {device['hostName']} in Fabric {fabric} is not in sync")
                    
                    # Retrieve missing configurations for out-of-sync devices
                    out_of_sync = ndfc_obj.get_device_missing_configs(fabric, device['serialNumber'])
                    
                    # Compile the list of missing commands into a message
                    commands = "\n".join(out_of_sync['pendingConfig'])
                    
                    # Send a message to the Webex Teams room
                    send_webex_message(f"The device {device['hostName']} in Fabric {fabric} is not in sync. \n\n {commands}")
    
    # Log script completion
    logging.info("Script completed")

# Entry point for the script
if __name__ == "__main__":
    main()