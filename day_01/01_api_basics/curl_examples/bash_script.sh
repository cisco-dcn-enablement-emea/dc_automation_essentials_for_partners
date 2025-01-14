#!/bin/bash

# Configuration
DATA_URL="http://127.0.0.1"
API_USERNAME="user1"
API_PASSWORD="password1"

# Use Basic HTTP authentication for the API call and add the result in a variable
response=$(curl -s -X GET "$DATA_URL/objects" \
     -u "$API_USERNAME:$API_PASSWORD" \
     -H "Content-Type: application/json")

# If the response is empty, print a warning message
if [ -z "$response" ]; then
    echo "Warning: No data received"
else
    # Print the response
    echo "$response"
fi

# Enter a while loop that asks the user to input as many as TLV objects he wants, until he types "exit"
while true; do
    # Ask the user to input the TLV object
    read -p "Enter the new object (type 'exit' to quit): " new_object

    # If the user types "exit", break the loop
    if [ "$new_object" == "exit" ]; then
        break
    fi

    # Use Basic HTTP authentication for the API call and add the result in a variable, data must be a valid json string contained inside the "data" field
    response=$(curl -s -X POST "$DATA_URL/objects" \
         -u "$API_USERNAME:$API_PASSWORD" \
         -H "Content-Type: application/json" \
         -d "{\"data\": $new_object}")


    # If the response is empty, print a warning message
    if [ -z "$response" ]; then
        echo "Warning: No data received"
    else
        # Print the response
        echo "Created new object $response"
    fi
done

# Use Basic HTTP authentication for the API call and add the result in a variable
response=$(curl -s -X GET "$DATA_URL/objects" \
     -u "$API_USERNAME:$API_PASSWORD" \
     -H "Content-Type: application/json")

# If the response is empty, print a warning message
if [ -z "$response" ]; then
    echo "Warning: No data received"
else
    # For each element in the response data field, print the object key
    for key in $(echo "$response" | jq -r '.data | keys[]'); do
        echo "Object key: $key"
    done
fi
