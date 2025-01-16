# Simple API

This directory contains a simple API implementation using Flask. The API provides basic CRUD operations for managing objects.

## Directory Structure

- `application.py`: The main application file that contains the Flask API implementation.
- `README.md`: This file, providing an overview of the project.
- static: contains openAPI test page

## Usage

### Running the API

To run the API, follow these steps:

1. Install the required dependencies:

```sh
pip install -r ../../requirements.txt
```

**File is located in the repository root**

2. Start the Flask application:

```sh
python application.py
```

### API Endpoints

The API provides the following endpoints:

- `GET /objects`: Retrieve a list of all objects.
- `GET /objects/<id>`: Retrieve a specific object by ID.
- `POST /objects`: Create a new object.
- `PUT /objects/<id>`: Update an existing object by ID.
- `DELETE /objects/<id>`: Delete an object by ID.

### Accessing the OpenAPI Test Page

The API includes an OpenAPI (Swagger) test page for easy interaction and testing. To access the OpenAPI test page, navigate to the following URL in your web browser:

```
http://127.0.0.1/swagger/
```

This page provides a user-friendly interface for testing the API endpoints and viewing the API documentation.

## Configuration

Ensure you have the necessary configuration and environment variables set up before running the application. For example, you may need to set the Flask environment variables for development or production.

## Dependencies

Ensure you have the required Python packages installed. You can install them using the requirements.txt  file located in the root directory of the project.

```sh
pip install -r ../../requirements.txt
```
