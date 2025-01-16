# Example 06 - Terraform examples with different strategies

This section contains a set of different examples of Terraform configuration files for automating Cisco ACI, following different strategies to organize variables and configuration files.

# Backend and Credentials

Examples included here use Terraform OSS (CLI) and remote backend, and hence state will be stored in a remote backend (HCP Terraform, former Terraform Cloud).

These demos are built using password-based authentication. The value for the provider variables are set in a providers.auto.tfvars file that has been excluded from the repository. 

Before running these demos, please:

* Provide the correct values for provider variables for your environment.
* Modify the backend configuration to use your own organization and workspace in HCP Terraform Cloud (free tier can be used for these demos). Workspace needs to be configured for local execution.

# Demos

## Full example with no modules
This example includes quite a complete deployment of couple of tenants with some bridge domains, app profiles, EPGs and contracts.

The objects to be configured are provided as variables, having one variable of type `map(object())` for every major type of object in the configuration.

Therefore, the code relies on `for_each` loops and nested loops to loop over those maps and create all resources described in variables while keeping the code almost static.

### Considerations
This approach brings some challenges:

First, in order to instruct terraform about the dependencies between objects, we define in the variables the key of the target object for every relation, given that Terraform does not support dynamic values (using interpolation) in tfvars files.

While this resolves the issue and allow us to build the dependencies correctly, it requires that the target object is managed from Terraform (otherwise the key will not exist).

Second, for those objects that have nested structures (such as filters), we need to use `flatten` to convert these nested structures into a flat one.

### How to run the demo
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

## Full example with no modules and nested variables
This demo provision the same infrastructure as the previous one, but the variables are all merged into a single `tenant` variable that follows a similar tree structure to the one that can be found in an aci configuration in XML or JSON.

### Considerations
While this approach makes the variable definition more user-friendly, and makes no longer needed some references to the parent object, it increases the complexity of the code because we need more often to rely on `flatten` to loop over the nested structures.

Also, this approach continues to have the challenge of defining the dependencies between objects in the variable file. As in the previous demo, we rely on the key to build those dependencies in the code.

### How to run the demo
To run the demo, use the following commands:

```
$ terraform init
$ terraform plan
$ terraform apply
```

Same as in previous demos, output of the plan can be saved and passed to apply as argument. Similarly, created infrastructure can be destroyed using ```terraform destroy``` command.

## Full example with modules
This demo provision the same infrastructure as the previous ones. In this example, we no longer rely on variables and `for_each` loops to keep our code DRY. Instead, we leverage modules to provision the typical infrastructure resources we need while making them simpler to use and easy to share and reuse.

Using modules, we can define some default values for non-set variables, define validation rules, and hardcode some attributes in the inner resources, simplifying our code.

Modules are defined locally under the module folder. In a production environment, modules should be published in a shared location, such as GitHub or, preferably, a private registry.

### Considerations
In this example, we no longer find the benefit of defining the infrastucture in a separated variable. That also has the benefit of removing the challenge of the dependencies we mentioned in previous examples.

### How to run the demo
To run the demo, use the following commands:

```
$ terraform init
$ terraform plan
$ terraform apply
```

Same in previous demos, output of the plan can be saved and passed to apply as argument. Similarly, created infrastructure can be destroyed using ```terraform destroy``` command.

