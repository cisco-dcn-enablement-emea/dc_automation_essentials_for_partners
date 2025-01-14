# Postman Files

This section contains all the necessary Postman files to replicate the demonstrations from our workshop. These files include:

- **CSV File**: Utilized for data-driven testing.
- **POST Request Body**: To be used with the CSV file.
- **OpenAPI Specification File**: Available for download from the test page or located in this repository at `day_01/00_simple_api/static/swagger.yml`.

### Prerequisites
Ensure you have Postman installed on your machine to use these files effectively. You can download it from [Postman's official site](https://www.postman.com/downloads/).

### Instructions for Importing and Using Files

1. **Download the Provided Postman Files**:
   - Ensure you have downloaded the OpenAPI specification file from the repository or the test page.

2. **Open Postman and Import Files**:
   - Launch Postman and click on the "Import" button located at the top-left corner of the interface.
   - Select the OpenAPI file from your downloaded files.

3. **Configure Import Settings**:
   - In the "Choose how to import your API" dialog, select "OpenAPI 2.0 with a Postman Collection".
   - Click on "View Import Settings" to customize the import:
     - In "Folder organization", choose "Tags".

4. **Complete the Import Process**:
   - Navigate back using the top-left arrow icon.
   - Click "Import" to finalize and import the files.

5. **Using the Imported Collection**:
   - Access the imported collection and the environment within Postman.
   - Use these to reproduce the API requests as demonstrated during the workshop.

### Additional Tips
- Ensure your API base URL and any required authentication details are configured in the Postman environment settings.
- Refer to the workshop materials for specific examples and use cases.

Happy testing!