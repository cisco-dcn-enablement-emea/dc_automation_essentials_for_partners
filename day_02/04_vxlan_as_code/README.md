# Ansible NDFC VXLAN Data Model

This example will push the entire configuration for the CML VXLAN EVPN fabric https://github.com/alessandro-deprato/vxlan-wks-topologies

This folder contain only the data model to be used with cisco.nac_dc_vxlan

Follow the instructions contained into the repository https://github.com/netascode/ansible-dc-vxlan-example to install the entire solution and eventually replace only the host_vars/nac-ndfc1 contents

## Secrets

Secrets and passwords are defined via environment variable as per https://github.com/netascode/ansible-dc-vxlan-example instructions
Serial numbers on devices are not real but aut-generated for Nexus9K virtual platforms