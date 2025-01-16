## Summary

This section contains a set of different examples of Terraform configuration files for automating Cisco ACI that were used during the **Data Center Networking Automation - Essentials Workshop** webinar delivered in EMEA in January 2025.

## Backend and Credentials

Examples included here use Terraform OSS (CLI) and local backend, and hence state file will be stored locally in the folder of each of the demos.

These demos are built using certificate-based authentication. Private key file is included in folder ```./pki/``` and is called labadmin.key. This information, including username, path, key and certificate name can be modified in the provider configuration:

```hcl
provider "aci" {
  username = "orchestrator"
  private_key = "../pki/labadmin.key"
  cert_name = "labadmin.crt"
  url      = "https://my-apic.example"
  insecure = true
}
```

## Demos

### Demo 01
The simplest example of a Terraform configuration file for Cisco ACI, with no variables, no modules and no flow controls at all.

To run the demo, use the following commands:

```
$ terraform init
$ terraform plan
$ terraform apply
```

The output of a plan can be saved to a file and passed to apply command:

```
$ terraform plan -out myplan.tfplan
$ terraform apply myplan.tfplan
```

To clean-up and destroy the created infrastructure in this demo:

```
$ terraform destroy
```

### Demo 02
Building on top of previous demo, these configuration files includes variables, which are declared in the file ```variables.tf```. The variable values are set in a tfvars file that needs to be passed as argument when running plan and apply. 

To run the demo, use the following commands:

```
$ terraform init
$ terraform plan -var-file demo02.tfvars
$ terraform apply -var-file demo02.tfvars
```

Same in previous demos, output of the plan can be saved and passed to apply as argument. Similarly, created infrastructure can be destroyed using ```terraform destroy``` command.

### Demo 03
Building on top of previous demo, this playbook uses for_each loops to iterate over a set or map of items (in this example, bridge domains). This demo demonstrate how we can avoid repetition in our code by creating multiple elements of the same class, each with different attributes as defined in the set/map.

In this example, variables are set in an *auto.tfvars file and hence there is no need to pass it as argument to plan and apply commands: terraform will automatically load variable definitions in *auto.tfvars files.

To run the demo, use the following commands:

```
$ terraform init
$ terraform plan
$ terraform apply
```

Same in previous demos, output of the plan can be saved and passed to apply as argument. Similarly, created infrastructure can be destroyed using ```terraform destroy``` command.

### Demo 04
This demo enhances previous demo including also conditionals, both in-line and using expressions in the for_each meta-argument.

To run the demo, use the following commands:

```
$ terraform init
$ terraform plan
$ terraform apply
```

Same in previous demos, output of the plan can be saved and passed to apply as argument. Similarly, created infrastructure can be destroyed using ```terraform destroy``` command.

### Demo 05
Building on top of previous demos, this demo includes the usage of modules. A terraform module for implementing a L3Out with BGP peering has been created locally. 

```
modules
└── aci_l3out
    ├── main.tf
    ├── outputs.tf
    └── variables.tf
```

The module is later used in the root module to instanciate the L3Out, as follows:

```hcl
module "l3out_core" {
    source = "./modules/aci_l3out"
    
    tenant_id = aci_tenant.demo.id
    name = "core_l3out"
    vrf_id = aci_vrf.main.id
    l3_ext_domain_id = data.aci_l3_domain_profile.core_l3dom.id
    nodes = {
        103 = {
            pod_id = "1"
            node_id = "103"
            rtr_id = "51.1.1.1"
            rtr_id_loopback = "no"
        }
    }
    paths = {
        "103.1.19" = {
            pod_id = "1"
            node_id = "103"
            port_id = "eth1/19"
            ip_addr  = "5.5.1.2/24"
            mode = "regular"
            mtu = "inherit"
        }
    }
    bgp_peers = {
        asa = {
            peer_addr = "5.5.1.1"
            peer_asn = "65099"
            local_asn = "65001"
        }
    }
    external_epgs = {
        default = {
            name = "default_l3epg"
            prefGrp = "exclude"
            provided_contracts = ["default"]
            consumed_contracts = []
            subnets = {
              "0.0.0.0" = {
                ip = "0.0.0.0/0"
                scope = ["import-security"]
              }
            }
        }
    }
}
```

Within the module code, some other advanced variable manipulation is done in order to, for example, iterate over nested objects (subnets within external EPGs).

To run the demo, use the following commands:

```
$ terraform init
$ terraform plan
$ terraform apply
```

Same in previous demos, output of the plan can be saved and passed to apply as argument. Similarly, created infrastructure can be destroyed using ```terraform destroy``` command.