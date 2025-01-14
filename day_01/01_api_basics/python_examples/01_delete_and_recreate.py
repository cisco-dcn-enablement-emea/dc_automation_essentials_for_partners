import api_class
import os

# Create a new API client instance with specified credentials
client = api_class.APIClient('http://127.0.0.1:80','user1', 'password1')

# Delete all existing objects
objects, status_code = client.get_objects()  # Fetch all objects
for object_key in objects["data"].keys():
    # Iterate over each object key and delete the object
    client.delete_object(object_key)

input("Press Enter to recreate objects...")

# Recreate objects by reading them from a CSV file located at '../postman_files/csv_data.csv'.
# The CSV's first line contains column names, which will be used as keys in the JSON object.
# Find me the relative path starting from the script file and ending at the csv file. ../postman_files/csv_data.csv
# Open the CSV file in read mode
script_path = os.path.dirname(os.path.realpath(__file__))
with open(f'{script_path}/../postman_files/csv_data.csv', 'r') as file:
    lines = file.readlines()  # Read all lines from the CSV file
    keys = lines[0].strip().split(',')  # Extract the column names as keys
    # Iterate over each subsequent line in the CSV
    for line in lines[1:]:
        values = line.strip().split(',')  # Extract the values for each column
        data = dict(zip(keys, (value.lower() for value in values)))  # Create a dictionary using column names as keys
        client.create_object(data)  # Create a new object with the data