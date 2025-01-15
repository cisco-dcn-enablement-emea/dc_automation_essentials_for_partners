#!/usr/bin/env python3

import json
import logging
import requests
from requests.packages.urllib3.exceptions import InsecureRequestWarning

# Initialize the logger for the module
LOG = logging.getLogger("__name__")

class Ndfc(object):
    """
    Master Class for NDFC API
    """

    def __init__(self, address: str, credentials: dict = None, api_key: dict = None):
        """Initializes an NDFC API object

        Args:
            address (str): IP Address or FQDN of the NDFC server
            credentials (dict, optional): Dictionary with user credentials {"userName":"","userPasswd":"","domain":""}
            api_key (dict, optional): Dictionary containing API key and username for authentication
        """
        
        # Disable insecure request warnings for HTTPS
        requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

        LOG.info("A new NDFC Instance is being started")
        # Attribute initialization
        self._address = address
        self._url = f"https://{address}/appcenter/cisco/ndfc/api/v1/lan-fabric/rest/"
        self._token = None
        self._credentials = credentials
        # Create a session object for persistent settings and connection reuse
        self.session = requests.Session()
        
        if api_key:
            # If an API key is provided, set it in the session headers
            LOG.info("Setting API Key")
            self.session.headers.update({
                "X-Nd-Apikey": api_key["api_key"],
                "X-Nd-Username": api_key["username"]
            })
        elif credentials:
            # If credentials are provided, perform authentication to obtain a token
            LOG.info("Attempting NDI Auth with credentials")
            self.get_nd_token(credentials)

    def __str__(self):
        return "This is an NDFC object"

    @property
    def address(self):
        """Get the NDFC server address"""
        return self._address

    @address.setter
    def address(self, value):
        """Set the NDFC server address"""
        self._address = value

    @property
    def credentials(self):
        """Get user credentials"""
        return self._credentials

    @credentials.setter
    def credentials(self, value):
        """Set user credentials"""
        self._credentials = value

    @property
    def token(self):
        """Get the authentication token"""
        return self._token

    @token.setter
    def token(self, value):
        """Set the authentication token"""
        self._token = value

    @property
    def url(self):
        """Get the base URL for API requests"""
        return self._url

    @url.setter
    def url(self, value):
        """Set the base URL for API requests"""
        self._url = value

    def get_nd_token(self, credentials):
        """
        Authenticates using user credentials to obtain a token stored as a cookie.
        The token is used for subsequent API requests.
        
        Args:
            credentials (dict): User credentials for authentication
        
        Returns:
            bool: True if authentication is successful, False otherwise
        """
        auth_url = f"https://{self.address}/login"
        LOG.debug(f"Running Auth query at {auth_url}")
        # Send a POST request to the login endpoint with the provided credentials
        auth_result = self.session.post(auth_url, json=credentials, verify=False)

        if auth_result.status_code == 200:
            # Update the session's cookies with the JWT token on successful authentication
            self.session.cookies.update({"AuthCookie": auth_result.json()["jwttoken"]})
            LOG.info("Authentication succeeded")
        else:
            LOG.error(f"Authentication failed, {auth_result.status_code}, {auth_result.text}")
            return False
        return True

    def generic_get(self, uri_object):
        """
        Sends a GET request to the specified URI object.
        
        Args:
            uri_object (str): The endpoint path for the GET request
        
        Returns:
            tuple: A tuple containing a boolean for success and the JSON response data
        """
        url = f"{self.url}/{uri_object}"
        LOG.debug(f"GET URL: {url}")
        # Use the session to send the GET request
        result = self.session.get(url, verify=False)
        if 199 < result.status_code < 300:
            LOG.debug(f"GET to {url} completed")
            return True, result.json()
        else:
            LOG.error(f"GET failed, {result.status_code}, {result.text}")
            return False, ""

    def generic_post(self, uri_object, payload=None, files=None):
        """
        Sends a POST request to the specified URI object with an optional payload.
        
        Args:
            uri_object (str): The endpoint path for the POST request
            payload (dict, optional): JSON payload for the POST request
            files (dict, optional): Files to upload with the request
        
        Returns:
            tuple: A tuple containing a boolean for success and the JSON response data
        """
        url = f"{self.url}/{uri_object}"
        LOG.debug(f"POST URL: {url}")
        # Use the session to send the POST request
        result = self.session.post(url, verify=False, json=payload, files=files)
        if 199 < result.status_code < 300:
            LOG.debug(f"POST to {url} completed")
            return True, result.json()
        else:
            LOG.error(f"POST failed, {result.status_code}, {result.text}")
            return False, ""

    def generic_put(self, uri_object, payload=None, files=None):
        """
        Sends a PUT request to the specified URI object with an optional payload.
        
        Args:
            uri_object (str): The endpoint path for the PUT request
            payload (dict, optional): JSON payload for the PUT request
            files (dict, optional): Files to upload with the request
        
        Returns:
            tuple: A tuple containing a boolean for success and the JSON response data
        """
        url = f"{self.url}/{uri_object}"
        LOG.debug(f"PUT URL: {url}")
        # Use the session to send the PUT request
        result = self.session.put(url, verify=False, json=payload, files=files)
        if 199 < result.status_code < 300:
            LOG.debug(f"PUT to {url} completed")
            return True, result.json()
        else:
            LOG.error(f"PUT failed, {result.status_code}, {result.text}")
            return False, ""

    def generic_delete(self, uri_object):
        """
        Sends a DELETE request to the specified URI object.
        
        Args:
            uri_object (str): The endpoint path for the DELETE request
        
        Returns:
            tuple: A tuple containing a boolean for success and the JSON response data
        """
        url = f"{self.url}/{uri_object}"
        LOG.debug(f"DELETE URL: {url}")
        # Use the session to send the DELETE request
        result = self.session.delete(url, verify=False)
        if 199 < result.status_code < 300:
            LOG.debug(f"DELETE to {url} completed")
            return True, result.json()
        else:
            LOG.error(f"DELETE failed, {result.status_code}, {result.text}")
            return False, ""

    # Other methods remain unchanged
    
    def get_device_missing_configs(self, fabric, device=None):
        """
        Retrieves the pending configuration for a specific device within a given fabric.

        Args:
            fabric (str): The name of the fabric to query.
            device (str, optional): The specific device to get pending configurations for. If None, retrieves for all devices.

        Returns:
            bool or dict: False if the request fails, otherwise a dictionary containing the pending configuration data.
        """
        url = f"control/fabrics/{fabric}/pendingConfig/{device}"
        result, data = self.generic_get(url)
        if not result:
            return False
        else:
            return data

    def force_calculate_device_diff(self, fabric, devices):
        """
        Forces a recalculation of the configuration differences for specified devices within a fabric.

        Args:
            fabric (str): The name of the fabric to query.
            devices (str): Comma-separated list of device identifiers.

        Returns:
            bool or dict: False if the request fails, otherwise a dictionary with the configuration differences.
        """
        url = f"control/fabrics/{fabric}/config-preview/{devices}?forceShowRun=true&showBrief=false&recomputeMapEnable=false&shRunOptimization=true"
        result, data = self.generic_get(url)
        if not result:
            return False
        else:
            return data

    def get_all_interfaces_by_serial(self, device):
        """
        Retrieves detailed interface information for a specific device based on its serial number.

        Args:
            device (str): The serial number of the device to query.

        Returns:
            bool or dict: False if the request fails, otherwise a dictionary with interface details.
        """
        url = f"interface/detail/filter?serialNumber={device}"
        result, data = self.generic_get(url)
        if not result:
            return False
        else:
            return data

    def get_all_fabrics(self) -> list:
        """Retrieves all the fabrics managed by the NDFC Cluster.

        Returns:
            list: A list of dictionaries. Each dictionary contains information about one fabric.
        """
        uri = "control/fabrics"
        result, data = self.generic_get(uri)
        if not result:
            return False
        else:
            return data

    def get_all_nodes_by_fabric(self, fabric: str) -> list:
        """Retrieves a list of nodes discovered by the NDFC Cluster within a specific fabric.

        Args:
            fabric (str): The name of the NDFC Fabric.

        Returns:
            list: A list of dictionaries. Each dictionary contains information about a switch.
        """
        uri = f"control/fabrics/{fabric}/inventory/switchesByFabric"
        result, data = self.generic_get(uri)
        if not result:
            return False
        else:
            return data

    def get_all_interfaces_by_node(self, node_serial: str) -> list:
        """Retrieves a list of interfaces associated with a single node.

        Args:
            node_serial (str): The serial number of the node/switch.

        Returns:
            list: A list of dictionaries. Each dictionary contains information about an interface.
        """
        uri = f"interface/detail?serialNumber={node_serial}"
        result, data = self.generic_get(uri)
        if not result:
            return False
        else:
            return data

    def get_all_vrfs_by_fabric(self, fabric: str) -> list:
        """Retrieves a list of VRFs (Virtual Routing and Forwarding instances) discovered by the NDFC Cluster within a specific fabric.

        Args:
            fabric (str): The name of the NDFC Fabric.

        Returns:
            list: A list of dictionaries. Each dictionary contains information about a VRF.
        """
        uri = f"/top-down/fabrics/{fabric}/vrfs"
        result, data = self.generic_get(uri)
        if not result:
            return False
        else:
            return data