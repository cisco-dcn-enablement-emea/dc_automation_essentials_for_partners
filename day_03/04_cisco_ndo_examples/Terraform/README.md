# Cisco Nexus Dashboard Orchestrator - Terraform Examples

## Summary

This section contains a couple of examples of Terraform configuration files for automating Cisco NDO, aiming at demonstrating how the cisco.mso provider works and some of the challenges that can be presented while using it.

## Backend and Credentials

Examples included here use Terraform OSS (CLI) and local backend, and hence state file will be stored locally in the folder of each of the demos.

## Demos

### Demo 01
This demo deploys a basic configuration on NDO, consisting on a tenant, a schema, a set of templates, and several objects inside each of the templates. Finally, the templates are deployed.

However, this demo presents an issue on purpose: template deployment will not be the last resource to run, resulting in a configuration that will only be partially deployed. Following demos will resolve this issue.

To run the demo, use the following commands:

```
$ terraform init
$ terraform plan
$ terraform apply -parallelism 1
```

To clean-up and destroy the created infrastructure in this demo:

```
$ terraform destroy -parallelism 1
```

### Demo 02
Building on top of previous demo, this demo resolves the issue with the template not being deployed at the end of the plan. The solution consists on including template configuration in a separated local module. Templates deployers then depends on this module, hence ensuring the correct order of operations.

To run the demo, use the following commands:

```
$ terraform init
$ terraform plan
$ terraform apply -parallelism 1
```

Same in previous demo, created infrastructure can be destroyed using `terraform destroy` command.