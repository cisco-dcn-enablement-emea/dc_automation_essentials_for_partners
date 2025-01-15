import requests

# This is a simple class that wraps the REST API for the BIND DNS server available here:
# https://gitlab.com/jaytuck/bind-rest-api
# This class should not be used in production, I quickly put it together for the purpose of the DEMO ONLY.

class BindRestAPI:
    def __init__(self, base_url, api_key):
        self.base_url = base_url
        self.headers = {
            'X-Api-Key': api_key,
            'Content-Type': 'application/json'
        }

    def get_zone(self, zone_name):
        """Get the JSON representation of a DNS zone."""
        url = f"{self.base_url}/dns/zone/{zone_name}"
        response = requests.get(url, headers=self.headers)
        return response.json()

    def get_record(self, domain, record_type=None):
        """Get a DNS record."""
        url = f"{self.base_url}/dns/record/{domain}"
        params = {'record_type': record_type} if record_type else {}
        response = requests.get(url, headers=self.headers, params=params)
        return response.json()

    def create_record(self, domain, record):
        """Create a new DNS record."""
        url = f"{self.base_url}/dns/record/{domain}"
        response = requests.post(url, headers=self.headers, json=record)
        return response.json()

    def replace_record(self, domain, record):
        """Replace an existing DNS record."""
        url = f"{self.base_url}/dns/record/{domain}"
        response = requests.put(url, headers=self.headers, json=record)
        return response.json()

    def delete_single_record(self, domain, record):
        """Delete a single DNS record."""
        url = f"{self.base_url}/dns/record/{domain}"
        response = requests.delete(url, headers=self.headers, json=record)
        return response.json()

    def delete_record_type(self, domain, record_types=None):
        """Delete all records of a specific type for a domain."""
        url = f"{self.base_url}/dns/allrecords/{domain}"
        params = {'recordtypes': record_types} if record_types else {}
        response = requests.delete(url, headers=self.headers, params=params)
        return response.json()

# # Example usage
# if __name__ == "__main__":
#     api_client = BindRestAPI(base_url="http://10.58.30.171:8000", api_key='YOUR_API_KEY')

#     # Example of creating a DNS record
#     record_data = {
#         "response": "10.9.1.136",
#         "rrtype": "A",
#         "ttl": 300
#     }
#     ptr_record_data = {
#         "response": "adp2.photonic.lab.",
#         "rrtype": "PTR",
#         "ttl": 300
#     }
#     print(api_client.create_record("adp.photonic.lab", record_data))
#     print(api_client.create_record("136.1.9.10.in-addr.arpa", ptr_record_data))