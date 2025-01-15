import os
import sys
import requests
from pprint import pprint
from urllib3.exceptions import InsecureRequestWarning

# Disable warnings about insecure HTTPS requests
requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

# Create a persistent session for making multiple requests
session = requests.Session()

# Define the base URL for NDFC API access
ndfc_address = "10.58.31.9/appcenter/cisco/ndfc/api/v1/lan-fabric/rest/"

# Prepare the payload with login credentials and domain for authentication
payload = {
    "userName": "admin",
    "userPasswd": os.getenv("LAB_PASSWORD"),  # Retrieve password from environment variables for security
    "domain": "DefaultAuth"
}

# Attempt to authenticate with the NDFC by sending a POST request with the payload
response = session.post(f"https://10.58.31.9/login", json=payload, verify=False)

# Check if the authentication was successful (status code 200-299)
if not (199 < response.status_code < 300):
    # Print error message and exit if authentication fails
    print(f"Error Authenticating - {response.text}")
    sys.exit(1)
else:
    # Confirm successful authentication
    print("Authentication Passed")

# Retrieve VRF information for a specific fabric from the NDFC
response = session.get(f"https://{ndfc_address}/top-down/fabrics/mil-cml-msd-wks-fabric/vrfs", verify=False)

# Parse the JSON response to extract VRF details
vrf_result = response.json()

# Iterate over each VRF in the result
for vrf in vrf_result:
    # Extract and print the VRF name
    vrf_name = vrf["vrfName"]
    print(f'\nVRF: {vrf_name}')

    # Retrieve network information for each VRF
    response = session.get(f"https://{ndfc_address}/top-down/v2/fabrics/mil-cml-msd-wks-fabric/networks?vrf-name={vrf_name}", verify=False)
    
    # Parse the JSON response to extract network details
    networks = response.json()

    # Iterate over each network within the VRF
    for network in networks:
        # Print the network's display name and gateway IP address
        print(f'Name: {network["displayName"]} -- DAG: {network["networkTemplateConfig"]["gatewayIpAddress"]}')