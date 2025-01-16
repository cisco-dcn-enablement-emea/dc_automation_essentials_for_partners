## Summary

This section contains an example of ansible playbooks for automating Cisco Nexus Dashboard Orchestrator

## Inventory

The inventory includes not only NDO but also APICs on both sites, although those are not used in any of the playbooks provided in this repository.

## Demo Description

This demo consists on a master playbook called `ndo_master_playbook.yaml` where other files with tasks are included. There are 7 files with tasks that are included:

* File `schema.yaml`, which creates a new tenant in NDO, together with one schema and 3 templates (Streched + Local templates). 
* File `stretched-base.yaml`, which creates several objects inside the Stretched Base template (VRF, Contracts, Filters,...)
* File `stretched.yaml`, which creates several objects inside the Stretched template (BDs, ANP, EPGs, ...)
* File `mdr-only.yaml`, which creates several objects inside the MDR1Only template (BDs, ANP, EPGs, ...)
* File `mlg-only.yaml`, which creates several objects inside the MLG1Only template (in this particular example, there are no objects created)
* File `deploy.yaml`, which for each template, and in the right order, performs a deployment plan preview and saves it into a file, and finally deploys the template. This file is only included if `deployment_state` is NOT `undeploy`.
* File `undeploy.yaml`, which undeploys the templates in the right order. This file is only included if `deployment_state` is `undeploy`.

## Instructions

These playbooks has been tested with Ansible 2.18 and Cisco NDO collection 2.9.0.

Cisco NDO ansible collection can be installed using the following command:

```
$ ansible-galaxy collection install cisco.ndo
```

Cisco NDO ansible collection can be upgraded using either --force option or --upgrade option (available in 2.10+):

```
$ ansible-galaxy collection install cisco.ndo --upgrade
```

Before using these playbooks, ansible inventory needs to modified according to your environment.

To run the playbooks:

```
$ ansible-playbook -i inventory.yaml ndo_master_config.yaml
```

If ansible vault is being used for encrypting sensitive variables (such as in this example), then use the following command:

```
$ ansible-playbook --vault-pass-file vault.key -i inventory.yaml ndo_master_config.yaml
```

where `vault.key` contains the passphrase used to encrypt the inventory or sensitive variables.

### Running only specific sections using tags

The playbook implements the following tags, allowing users to execute only specific pieces of the code as needed:
- configure
- deploy
- undeploy

You can specify the sections to run using the argument `--tags {{tags}}` or skip some parts using `--skip-tags {{tags}}`. For example:

Just configure the templates, without deploying them:
```
$ ansible-playbook -i inventory.yaml ndo_master_config.yaml --tags configure
```

Configure and deploy all the templates:
```
$ ansible-playbook -i inventory.yaml ndo_master_config.yaml --tags configure,deploy
```

Undeploy all the templates:
```
$ ansible-playbook -i inventory.yaml ndo_master_config.yaml --tags undeploy
```