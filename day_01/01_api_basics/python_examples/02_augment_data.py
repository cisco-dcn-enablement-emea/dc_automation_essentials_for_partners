import re
import openai
import api_class
import json

# Create a new API client instance with specified credentials
client = api_class.APIClient('http://127.0.0.1:80', 'user1', 'password1')

# Read OPENAI_API_KEY from environment variables (default behavior)
aiclient = openai.Client()

def augment_aircraft_data(aircraft):
    try:
        response = aiclient.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[
                {
                    "role": "system",
                    "content": "You are an expert on aircraft specifications. Provide only a json data model that answer the requirements."
                },
                {
                    "role": "user",
                    "content": 'Fill the following json file based on technical data for the %s %s aircraft. \'{"introduce_year": "", "role": "", "country_of_origin": "", "mach_top_speed": "", "range_in_km": "", "engine_type": ""}\' Enclose the json string in triple quotes.' %(aircraft["model"], aircraft["manufacturer"])
                }
            ],
            max_tokens=150
        )
        # Extract the content from the assistant's message
        detailed_info = response.choices[0].message.content.strip()
        pattern = r"{[^}]*\}"
        detailed_info = re.search(pattern, detailed_info).group(0)
        # Extract the json string from the assistant's message
        try:
            return json.loads(detailed_info)
        except json.JSONDecodeError as e:
            return f"Failed to decode JSON: {e}"
        
    except Exception as e:
        return f"An error occurred: {e}"

# Fetch all existing objects
objects, status_code = client.get_objects()  # Ensure this returns {"data": {...}}

if status_code == 200 and "data" in objects:
    for key, aircraft in objects["data"].items():
        detailed_info = augment_aircraft_data(aircraft)
        
        if isinstance(detailed_info, dict):
            aircraft["details"] = detailed_info
            client.modify_object(key, aircraft)
        else:
            print(f"Error processing data for {aircraft['manufacturer']} {aircraft['model']}: {detailed_info}")
else:
    print("Failed to fetch objects or invalid response structure.")