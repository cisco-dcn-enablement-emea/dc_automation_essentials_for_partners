# Automation Workshop

This repository contains various automation examples and exercises used for the EMEA Partners Datacenter Automation Essentials workshop,. The examples cover a range of automation tools and techniques, including APIs, Ansible, Terraform, and CI/CD pipelines.

** Detailed README files are contained in the subfolders **


## Day 1

### 00_simple_api

A simple API implementation using Flask. The API provides basic CRUD operations for managing objects.

- **Running the API**:
  ```sh
  pip install -r ../../requirements.txt
  python application.py
  ```
  The API will be accessible at `http://127.0.0.1`.

### 01_api_basics

Basic API examples using curl, Postman, and Python.

- **curl_examples**: Scripts for interacting with APIs using curl.
- **postman_files**: Postman collections and environment files.
- **python_examples**: Python scripts for API interaction.

### 02_ansible_basics

Basic Ansible examples, including inventory and playbooks.

- **inventory**: Ansible inventory files.
- **playbooks**: Ansible playbooks used durung demos.

### 03_terraform_basics

Basic Terraform examples, including multiple demos.

- **demo01** to **demo05**: Terraform configuration files for different demos.

### 05_pipelines

CI/CD pipeline examples using GitLab CI and GitHub Actions.

- **example01_full_pipeline_gitlab**: Full pipeline example with GitLab CI.
- **example02_full_pipeline_github**: Full pipeline example with GitHub Actions.
