import re
import os
from pprint import pprint
from pygnmi.client import gNMIclient

# Remove any existing HTTP/HTTPS proxy settings to avoid connectivity issues
if os.environ.get('https_proxy'):
    del os.environ['https_proxy']
if os.environ.get('http_proxy'):
    del os.environ['http_proxy']

# Pattern to parse interface names
pattern = r"eth(\d+)/(\d+)"

# Inventory of devices
inventory = [{
    "host": "10.58.30.203",
    "auth_username": "admin",
    "auth_password": os.getenv("LAB_PASSWORD"),
    "port": 50051,
    "path": "myCA.pem", # Ensure that you have this Certification Authority pem file in the folder. Follow 00_enable_gnmi_on_nx-os.md instructions 
    "insecure": False
}]

# Function to query CDP neighbors
def query_cdp_neighbors(gconn):
    print("\nCDP Neighbors:")
    cdp = gconn.get(path=["/System/cdp-items/inst-items/if-items/If-list/adj-items/AdjEp-list/sysName"])
    for neighbor in cdp['notification'][0]['update']:
        path = neighbor['path']
        dev = neighbor['val']
        match = re.search(pattern, path)
        if match:
            print(f"{match.group(0)} ==> {dev}")

# Function to query route status
def query_route_status(gconn):
    print("\nThese are the VRFs:")
    vrfs = gconn.get(path=["/network-instances/network-instance"])
    for vrf in vrfs['notification'][0]['update']:
        for val in vrf['val']:
            print(f"VRF: {val['name']}")

# Function to subscribe to interface statistics
def subscribe_interface_statistics(gconn,interface=None):
    print("\nSubscribing to Interface Statistics:")
    subscription = gconn.subscribe(
        subscribe={
            'subscription': [
                {
                    # All Interfaces
                    # 'path': "/System/intf-items/phys-items/PhysIf-list",
                    'path': f'/interfaces/interface[name={interface}]/state/counters',
                    'mode': 'sample',
                    'sample_interval': 2000000000  # 2 seconds in nanoseconds
                }
            ],
            'use_aliases': False,
            'mode': 'stream'
        }
    )
    max_messages = 4 # Limit the number of messages for demonstration purposes
    for message in subscription:
        pprint(message)
        max_messages -= 1
        if max_messages == 0:
            break  # Stop after one message for demonstration purposes



# Shutdown interface with native model
def shut_interface(gconn, interface):
    print(f"\nConfiguring Interface {interface}:")
    
    # Construct the configuration payload as tuples
    print(f"/interfaces/interface[name={interface}]/config")
    config = [
        (
            f"/System/intf-items/phys-items/PhysIf-list[id={interface}]/",
            {
                # The 'name' value should match the list key in the path
                'adminSt': 'down'
            }
        )
    ]
    try:
        # Send the configuration request
        response = gconn.set(update=config)
        pprint(response)
    except Exception as e:
        print(f"Error configuring interface: {e}")

# No shut the interface with openconfig model
def no_shut_interface(gconn, interface):
    print(f"\nConfiguring Interface {interface}:")
    
    # Construct the configuration payload as tuples
    config = [
        (
            f"/interfaces/interface[name={interface}]/config",
            {
                # The 'name' value should match the list key in the path
                'enabled': True
            }
        )
    ]
    
    try:
        # Send the configuration request
        response = gconn.set(update=config)
        pprint(response)
    except Exception as e:
        print(f"Error configuring interface: {e}")

if __name__ == "__main__":
    for device in inventory:
        with gNMIclient(target=(device["host"], device["port"]),
                        username=device["auth_username"],
                        password=device["auth_password"],
                        path_cert=device["path"],
                        insecure=device["insecure"]
                        ) as gconn:
            print(f"\nConnected to {device['host']}")        

            # Query CDP neighbors
            query_cdp_neighbors(gconn)

            # Query route status
            query_route_status(gconn)

            # Subscribe to interface statistics
            subscribe_interface_statistics(gconn,"eth1/1")

            # Shutdown the interface
            shut_interface(gconn, "eth1/10")

            # No shut the interface
            no_shut_interface(gconn, "eth1/10")
