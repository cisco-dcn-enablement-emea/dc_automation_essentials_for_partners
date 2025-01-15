import os
import sys
import ipaddress
import logging
from libs import ndfc, dns

# Configure logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)-8s [%(filename)s:%(lineno)d] %(message)s")

# Define API key and username for NDFC access
api_key = {"api_key": f"{os.getenv('NDFC_CLUSTER_3_ADMIN_API_KEY')}", "username": "admin"}

# Define the DNS domain
dns_domain = "photonic.lab"

# List of managed subnets
managed_subnets = ["10.0.0.0/8", "172.20.0.0/16","172.19.0.0/16","20.0.0.0/8"]
included_fabrics = ["mil-cml-isn","mil-cml-vxlan-fabric-1","mil-cml-vxlan-fabric-2"]

def main():
    # Create a new NDFC object
    ndfc_obj = ndfc.Ndfc("10.58.31.9", api_key=api_key)

    # Create a DNS API client
    dns_api_client = dns.BindRestAPI(base_url="http://10.58.30.171:8000", api_key=os.getenv("BIND_API_KEY"))

    # Retrieve all fabrics and filter out specific types
    fabrics = [fabric['fabricName'] for fabric in ndfc_obj.get_all_fabrics() if fabric['templateFabricType'] != "VXLAN EVPN Multi-Site" and fabric['fabricName'] in included_fabrics]

    # Log the number of fabrics found
    logging.info(f"Found {len(fabrics)} fabrics")

    # Iterate over each fabric
    for fabric in fabrics:
        # Retrieve all devices within the fabric
        devices = ndfc_obj.get_all_nodes_by_fabric(fabric)

        # Log the number of devices found
        logging.info(f"Found {len(devices)} devices in Fabric {fabric}")

        # Iterate over each device
        for device in devices:
            # Retrieve all interfaces for the device
            interfaces = ndfc_obj.get_all_interfaces_by_serial(device['serialNumber'])

            # Iterate over each interface
            for interface in interfaces:
                # Skip interfaces without an IP address
                if not interface["ipAddress"]:
                    continue

                # Check each IP address of the interface
                for managed_subnet in managed_subnets:
                    for ip_address in interface["ipAddress"].split(" "):
                        try:
                            # Validate the IP address
                            ipaddress.IPv4Interface(ip_address)
                        except ipaddress.AddressValueError:
                            # Skip invalid IP addresses
                            continue

                        # Check for subnet overlap
                        if ipaddress.IPv4Network(ipaddress.IPv4Interface(ip_address).network).overlaps(ipaddress.IPv4Network(managed_subnet)):
                            logging.info(f"Interface {interface['ifName']} on device {device['hostName']} in Fabric {fabric} is in a managed subnet")

                            # Construct the DNS record name
                            record_name = f"{device['hostName']}-{interface['ifName'].replace('/', '-')}.{dns_domain}"

                            # Define the DNS 'A' record
                            dns_record = {
                                "response": ipaddress.IPv4Interface(ip_address).ip.compressed,
                                "rrtype": "A",
                                "ttl": 300
                            }

                            # Define the PTR record
                            ptr_record = {
                                "response": record_name,
                                "rrtype": "PTR",
                                "ttl": 300
                            }

                            # Create the DNS 'A' record, not needed in my case
                            #dns_api_client.create_record(record_name, dns_record)

                            # Create the PTR record
                            dns_api_client.create_record(ipaddress.IPv4Interface(ip_address).ip.reverse_pointer, ptr_record)

                        # Break after processing a matching subnet
                        break

    # Log completion of the script
    logging.info("Script completed")

# Entry point for the script
if __name__ == "__main__":
    main()