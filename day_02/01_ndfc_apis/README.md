# NDFC APIs

This directory contains scripts and libraries for interacting with Cisco's Nexus Dashboard Fabric Controller (NDFC) APIs. These scripts are designed to automate various tasks such as retrieving device information, updating DNS entries, and checking device status.

## Directory Structure

- `01_ndfc_direct_session.py`: A script to establish a direct session with the NDFC and retrieve VRF and network information.
- `02_ndfc_class.py`: A script similar to `01_ndfc_direct_session.py` but organized in a class structure for better modularity.
- `03_check_and_report_status copy.py`: A script to check the status of devices in the fabric and report any out-of-sync configurations to a Webex Teams room.
- `04_update_dns_entries.py`: A script to update DNS entries based on the devices and interfaces in the NDFC fabric.
- `libs/ndfc.py`: A library containing the `Ndfc` class, which provides methods for interacting with the NDFC API.
- `libs/dns.py`: A library for interacting with a BIND DNS server's REST API.

## Usage

### 01_ndfc_direct_session.py

This script establishes a direct session with the NDFC and retrieves VRF and network information.

```sh
python 01_ndfc_direct_session.py
```

### 02_ndfc_class.py

This script is similar to `01_ndfc_direct_session.py` but uses a class structure for better modularity.

```sh
python 02_ndfc_class.py
```

### 03_check_and_report_status copy.py

This script checks the status of devices in the fabric and reports any out-of-sync configurations to a Webex Teams room.

```sh
python 03_check_and_report_status\ copy.py
```

### 04_update_dns_entries.py

This script updates DNS entries based on the devices and interfaces in the NDFC fabric.

```sh
python 04_update_dns_entries.py
```

### libs/ndfc.py

This library contains the `Ndfc` class, which provides methods for interacting with the NDFC API. It includes methods for authentication, retrieving device information, and managing configurations.

### libs/dns.py

This library provides methods for interacting with a BIND DNS server's REST API. It includes methods for creating, updating, and deleting DNS records.

## Configuration

Before running the scripts, ensure you have the necessary configuration and environment variables set up. For example, you may need to set the NDFC API credentials and Webex Teams access token as environment variables.

## Dependencies

Ensure you have the required Python packages installed. You can install them using the 

requirements.txt

 file located in the root directory of the project.

```sh
pip install -r ../../requirements.txt
```
