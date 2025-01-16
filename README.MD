# Automation Workshop

Welcome to the **Automation Workshop** repository! This repository contains a collection of automation examples and exercises designed for the **EMEA Partners Datacenter Automation Essentials Workshop**. These examples showcase a range of automation tools and techniques, including APIs, Ansible, Terraform, and CI/CD pipelines.

---

## Professional Disclaimer

The configurations and examples in this repository were developed for a controlled lab environment. While they are valuable as references or starting points for automation projects, they should not be directly applied to production environments without thorough testing. Adjustments may be required to ensure compatibility, stability, and security in your specific environment.

---

## Table of Contents
- [Overview](#overview)
- [Day 1](#day-1)
  - [00_simple_api](#00_simple_api)
  - [01_api_basics](#01_api_basics)
  - [02_ansible_basics](#02_ansible_basics)
  - [03_terraform_basics](#03_terraform_basics)
  - [05_pipelines](#05_pipelines)
- [Day 2](#day-2)
  - [00_cml_topologies](#00_cml_topologies)
  - [01_ndfc_apis](#01_ndfc_apis)
  - [02_ndfc_ansible_automation](#02_ndfc_ansible_automation)
  - [03_nx-os_automation](#03_nx-os_automation)
  - [04_vxlan_as_code](#04_vxlan_as_code)
- [Day 3](#day-3)
  - [01_cisco_aci_api](#01_cisco_aci_api)
  - [02_cisco_ndo_api](#02_cisco_ndo_api)
  - [03_cisco_aci_examples](#03_cisco_aci_examples)
  - [04_cisco_ndo_examples](#04_cisco_ndo_examples)
- [License](#license)

---

## Overview

This repository provides hands-on examples and exercises to help participants learn and apply automation concepts effectively. Each example is structured into its own subfolder with detailed README files for additional guidance.

> **Note:** For more information, refer to the README files located within each subfolder.

---

## Day 1

### 00_simple_api
A simple API implementation using Flask. This API provides basic CRUD operations for managing objects.

#### Running the API
1. Install dependencies:
   ```sh
   pip install -r ../../requirements.txt
   ```
2. Start the API:
   ```sh
   python application.py
   ```
3. Access the API at `http://127.0.0.1`.

### 01_api_basics
Basic API interaction examples using curl, Postman, and Python.

#### Contents
- **`curl_examples`**: Scripts demonstrating API interaction with curl.
- **`postman_files`**: Postman collections and environment files.
- **`python_examples`**: Python scripts for API interaction.

### 02_ansible_basics
Introduction to Ansible, including inventory management and playbooks.

#### Contents
- **`inventory`**: Sample Ansible inventory files.
- **`playbooks`**: Ansible playbooks for demos.

### 03_terraform_basics
Basic Terraform examples showcasing multiple demos.

#### Contents
- **`demo01`** to **`demo05`**: Terraform configuration files demonstrating various scenarios.

### 05_pipelines
CI/CD pipeline examples leveraging GitLab CI and GitHub Actions.

#### Contents
- **`example01_full_pipeline_gitlab`**: A complete pipeline implementation with GitLab CI.
- **`example02_full_pipeline_github`**: A complete pipeline implementation with GitHub Actions.

---

## Day 2

### 00_cml_topologies
Examples and exercises related to Cisco Modeling Labs (CML) topologies.

### 01_ndfc_apis
Scripts and libraries for interacting with Cisco's Nexus Dashboard Fabric Controller (NDFC) APIs.

### 02_ndfc_ansible_automation
Ansible automation examples for NDFC.

### 03_nx-os_automation
Automation examples for Cisco NX-OS using Terraform and other tools.

### 04_vxlan_as_code
Ansible NDFC VXLAN Data Model examples.

---

## Day 3

### 01_cisco_aci_api
Examples and exercises for interacting with Cisco ACI APIs.

### 02_cisco_ndo_api
Examples and exercises for interacting with Cisco Nexus Dashboard Orchestrator (NDO) APIs.

### 03_cisco_aci_examples
Comprehensive examples for automating Cisco ACI using various tools and techniques.

### 04_cisco_ndo_examples
Comprehensive examples for automating Cisco NDO using various tools and techniques.

---

## License

This repository is licensed under the **Mozilla Public License, v. 2.0**. 

If a copy of the MPL was not distributed with this file, you can obtain one at [http://mozilla.org/MPL/2.0/](http://mozilla.org/MPL/2.0/).

---
