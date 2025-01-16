Role Name
=========

This role provides an abstraction layer to deploy a Cisco ACI tenant using a variable that represents, in an structured and friendly way, the configuration of your tenant.

This role has been created only for educational purposes, and therefore it only implements a subset of the tenant objects. It is provided as-is and not meant for production use.

Requirements
------------

The module uses the Cisco ACI collection (cisco.aci). It has been tested with version 2.10.1

Role Variables
--------------

data: a nested dictionary with a list of tenants at the root.

Dependencies
------------

- cisco.aci collection
- ansible.netcommon.httpapi connection plugin

Example Playbook
----------------

```yaml
    ---
    - name: Create Tenant
      hosts: apic
      gather_facts: no
    
      vars_files:
        - my_tenants_inventory_file.yaml
    
      roles:
        - role: cisco_aci_tenant
          data: "{{ data }}"

License
-------

Apache 2.0


