# Note: This is a simple API that allows to create, read, update and delete objects
#       The objects are stored in a dictionary in memory
#       The API is protected by basic authentication, users are stored in a dictionary in memory not encrypted
#       The API has a swagger UI to document the endpoints
#       The API has CORS enabled to allow requests from any origin
#       The API is running on port 80

import hashlib
import json
from flask import Flask, request, jsonify
from flask_httpauth import HTTPBasicAuth
from flask_swagger_ui import get_swaggerui_blueprint
from flask_cors import CORS

# Initialize the Flask application
app = Flask(__name__)

# Enable Cross-Origin Resource Sharing (CORS) to allow requests from any origin
CORS(app)

# Set up basic authentication
basic_auth = HTTPBasicAuth()

# In-memory storage for users and their passwords (not encrypted)
users = {
    "user1": "password1",
    "user2": "password2"
}

# In-memory storage for objects, with object ID as the key
objects = {}

@basic_auth.verify_password
def verify_password(username, password):
    # Verify the user's credentials
    if username in users and (users.get(username) == password):
        return username

@app.route('/objects', methods=['GET'])
@basic_auth.login_required
def get_objects():
    """Retrieve all objects or filter them by a specific key"""
    filter = request.args.get('filter')  # Get filter parameter from query string
    if filter:
        # Filter objects by the specified key
        filtered_objects = {k: v for k, v in objects.items() if filter == str(k)}
        return jsonify({"data": filtered_objects}), 200
    # Return all objects if no filter is applied
    return jsonify({"data": objects}), 200

@app.route('/objects/<obj_id>', methods=['GET'])
@basic_auth.login_required
def get_object(obj_id):
    """Retrieve a specific object by its unique ID"""
    if obj_id in objects:
        return jsonify({"data": objects[obj_id]}), 200
    # Return a 404 error if the object is not found
    return jsonify({"message": "Object not found"}), 404

@app.route('/objects', methods=['POST'])
@basic_auth.login_required
def create_object():
    """Create a new object and store it in the objects dictionary"""
    data = request.json.get('data')
    if data:
        # Generate a unique ID for the object using a hash of its data
        obj_id = hashlib.md5(str(data).encode()).hexdigest()
        if obj_id in objects.keys():
            # Return a conflict error if the object already exists
            return jsonify({"message": "Object already exists", "id": obj_id}), 409
        # Store the object data, ensuring it's in dictionary format
        if isinstance(data, str):
            objects[obj_id] = json.loads(data)
        elif isinstance(data, dict):
            objects[obj_id] = data
        else:
            # Return an error if the data type is invalid
            return jsonify({"message": "Invalid data type"}), 401
        # Return a success message with the object's ID
        return jsonify({"message": "Object created", "id": obj_id}), 201
    # Return an error if no data is provided
    return jsonify({"message": "No data provided"}), 400

@app.route('/objects/<obj_id>', methods=['PUT'])
@basic_auth.login_required
def modify_object(obj_id):
    """Modify an existing object by its ID"""
    if obj_id in objects.keys():
        # Update the object with the new data
        objects[obj_id] = request.json.get('data')
        return jsonify({"message": "Object modified"}), 200
    # Return a 404 error if the object is not found
    return jsonify({"message": "Object not found"}), 404

@app.route('/objects/<obj_id>', methods=['DELETE'])
@basic_auth.login_required
def delete_object(obj_id):
    """Delete an object by its ID"""
    if obj_id in objects:
        # Remove the object from the storage
        del objects[obj_id]
        return jsonify({"message": "Object deleted"}), 200
    # Return a 404 error if the object is not found
    return jsonify({"message": "Object not found"}), 404

# Swagger/OpenAPI UI setup for API documentation
SWAGGER_URL = '/swagger'
API_URL = '/static/swagger.yml'
swaggerui_blueprint = get_swaggerui_blueprint(SWAGGER_URL, API_URL, config={'app_name': "Partner Datacenter Automation Essentials Workshop"})
app.register_blueprint(swaggerui_blueprint, url_prefix=SWAGGER_URL)

# Run the Flask application
if __name__ == '__main__':
    # Host the API on all interfaces on port 80
    app.run(host='0.0.0.0', port=80, debug=True)