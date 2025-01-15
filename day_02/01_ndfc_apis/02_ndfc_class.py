import os
from libs import ndfc
from pprint import pprint

# Retrieve the API key for NDFC access from environment variables
# Define the API key and username needed for authentication with the NDFC
api_key = {"api_key": f"{os.getenv('NDFC_CLUSTER_3_ADMIN_API_KEY')}", "username": "admin"}

# Establish a connection to the NDFC using the specified IP address and API credentials
ndfc_conn = ndfc.Ndfc("10.58.31.9", api_key=api_key)

# Retrieve all fabric configurations available from the NDFC
fabric_result = ndfc_conn.get_all_fabrics()

# Iterate over each fabric obtained from the NDFC
for fabric in fabric_result:
    # Extract and print the name of the current fabric
    fabric_name = fabric["fabricName"]
    print(f"\nFabric: {fabric_name}")

    # Retrieve all nodes associated with the current fabric
    nodes = ndfc_conn.get_all_nodes_by_fabric(fabric_name)

    # Iterate over each node within the fabric
    for node in nodes:
        # Print the hostname, serial number, and management IP address for each node
        print(f'Hostname: {node["hostName"]} -- Serial: {node["serialNumber"]} -- ManagementIP: {node["ipAddress"]}')