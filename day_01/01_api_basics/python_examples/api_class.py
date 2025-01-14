import requests
from requests.auth import HTTPBasicAuth

class APIClient:
    # Base URL for the API endpoints
    
    def __init__(self, url, username, password):
        # Initialize the API client with basic authentication
        self.url = url
        self.auth = HTTPBasicAuth(username, password)

    def get_objects(self, filter=None):
        """Fetch all objects or a subset based on the filter.

        Args:
            filter (str, optional): A filter to apply when fetching objects.

        Returns:
            tuple: A tuple containing the response JSON and status code.
        """
        # Set up query parameters for the request, if a filter is provided
        params = {'filter': filter} if filter else {}
        # Make a GET request to retrieve objects
        response = requests.get(f'{self.url}/objects', params=params, auth=self.auth)
        # Return the JSON response and status code
        return response.json(), response.status_code

    def create_object(self, data):
        """Create a new object.

        Args:
            data (dict or str): The data for the new object.

        Returns:
            tuple: A tuple containing the response JSON and status code.
        """
        # Make a POST request to create a new object with the given data
        response = requests.post(f'{self.url}/objects', json={'data': data}, auth=self.auth)
        # Return the JSON response and status code
        return response.json(), response.status_code

    def get_object_by_id(self, obj_id):
        """Fetch a single object by ID.

        Args:
            obj_id (str): The unique ID of the object.

        Returns:
            tuple: A tuple containing the response JSON and status code.
        """
        # Make a GET request to retrieve a specific object by its ID
        response = requests.get(f'{self.url}/objects/{obj_id}', auth=self.auth)
        # Return the JSON response and status code
        return response.json(), response.status_code

    def modify_object(self, obj_id, data):
        """Modify an existing object by ID.

        Args:
            obj_id (str): The unique ID of the object to modify.
            data (dict or str): The new data to update the object with.

        Returns:
            tuple: A tuple containing the response JSON and status code.
        """
        # Make a PUT request to update the object with the given ID and new data
        response = requests.put(f'{self.url}/objects/{obj_id}', json={'data': data}, auth=self.auth)
        # Return the JSON response and status code
        return response.json(), response.status_code

    def delete_object(self, obj_id):
        """Delete an object by ID.

        Args:
            obj_id (str): The unique ID of the object to delete.

        Returns:
            int: The status code of the response.
        """
        # Make a DELETE request to remove the object with the specified ID
        response = requests.delete(f'{self.url}/objects/{obj_id}', auth=self.auth)
        # Return the status code of the response
        return response.status_code