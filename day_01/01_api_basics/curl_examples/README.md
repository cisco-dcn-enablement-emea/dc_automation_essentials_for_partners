# Bash Script for API Interaction

This Bash script is designed to interact with an API using Basic HTTP authentication. It performs several operations including fetching data, allowing user input for new objects, and displaying keys from the retrieved data.
It should be used together with the simple_api defined in this repository day_01/00_simple_api

## Prerequisites

- **Curl**: This script uses `curl` to make HTTP requests. Ensure that `curl` is installed on your system.
- **JQ**: The script uses `jq` to parse JSON data. You need to have `jq` installed to run the script successfully.

## Configuration

Before running the script, make sure to configure the following variables in the script to match your API credentials and endpoint:

- `DATA_URL`: The base URL of the API.
- `API_USERNAME`: The username for HTTP Basic Authentication.
- `API_PASSWORD`: The password for HTTP Basic Authentication.

## Script Functionality

1. **Fetch Data**: 
   - The script starts by fetching data from the API endpoint specified in `DATA_URL`.
   - It uses HTTP Basic Authentication with `API_USERNAME` and `API_PASSWORD`.

2. **User Input for New Objects**:
   - The script enters a loop where it prompts the user to input new TLV (Type-Length-Value) objects.
   - The user can continue to input objects until typing `exit` to quit the loop.
   - Each new object is sent to the API with a POST request, and the response is displayed.

3. **Display Object Keys**:
   - After the user exits the loop, the script fetches the latest data from the API.
   - It then prints each key from the objects received in the response.

## Usage

1. **Run the Script**:
   - Make sure the script is executable. You can set execute permissions with the following command:
     ```bash
     chmod +x script.sh
     ```
   - Execute the script:
     ```bash
     ./script.sh
     ```

2. **Input Objects**:
   - When prompted, input the TLV object in JSON format.
   - Type `exit` when you are done inputting objects.

3. **View Output**:
   - The script will display responses from API calls and print the keys of the objects fetched from the API.

## Notes

- Ensure that your input for new objects is a valid JSON string.
- Modify the `DATA_URL`, `API_USERNAME`, and `API_PASSWORD` variables in the script to match your API details before executing the script.

## Troubleshooting

- **No Data Received**: If you see a warning about no data received, check your API endpoint and credentials.
- **JSON Parsing**: Ensure `jq` is installed and available in your system path if you encounter issues with JSON parsing.
