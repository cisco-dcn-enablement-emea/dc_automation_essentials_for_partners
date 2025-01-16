# Example 03 - Ansible comprehensive example with and without roles

In this example, you will find a comprehensive example of how to use Ansible to automate large pieces of configuration, like in this case, most of the common objects within a tenant.

Two variants are presented to address this: the first one without roles, and a second one using roles.

## Deploy a Cisco ACI tenant without using roles

In this section, you can find an ansible playbook called `dev_tn_deploy.yaml` that includes several other playbooks, so that the configuration is modular and easier to maintain. 

All playbooks rely on an external variable file that uses a semi-nested structure to organize information logically. Because of the challenges to access nested dictionaries with more than 2 levels of depth, the schema used limits the depth to 2 levels.

The next scenario removes this limitation.

## Deploy a Cisco ACI tenant using roles

In this section, you can find an ansible playbook with the same name as before, but in this case it leverages an ansible role (included locally) called `cisco_aci_tenant` that takes nested dictionary (with no limits on depth) that represents a list of tenants, and deploys all the pieces included inside it.

In order to overcome the limitation of `subelements`, the role implements a custom filter (originally developed by Ramses Smeyers, Principal Engineer in TAC) that extracts from the nested dictionary a list that contains the elements at the selected level, appending a copy of all their parent's objects all the way from the root of the tree.

Note the variables file uses slightly different attributes nmames compared to previous example, to accomodate to the way the filter `aci_listify` works.

## Note about the variables file

The structure used to define the variables file may look similar to the one used by NetAsCode or Nexus-as-Code. The reason for this is that due to our experience with customers, working with a file that represents the configuration in a logically-organized and human-friendly structure makes managing the infrastructure easier.

There are several fundamental differences, including:

### Scope of the model

This is just an example for learning purposes and therefore just a subset of objects and attributes are available. Nexus-as-Code is way more comprehensive, and implement the vast majority of objects and classes used in Cisco ACI configurations.

### Declarativeness and Statefulness

The examples presented here inherit one of the big challenges of Ansible when used with inventory-like variable files and a network-as-code approach: when an object is modified in a way that needs recreation, or when an object is deleted from the variables file, Ansible does nothing about it.

Nexus-as-Code (or even the original ansible-based version of it) do not behave like this, and propely manage deletions and replacements.

## References

The role used in the second example is inspired on a role that was developed several years ago, and that can be found here:
[GitHub: datacenter/ansible-role-aci-model](https://github.com/datacenter/ansible-role-aci-model/blob/master/README.md)

This role is no longer maintained and obsolete, even though it can still be useful for learning purposes. The role used here is a reduced (but updated) version of that one, and also uses the same custom jinja filter, with the sole purpose of demonstrate how ansible functionality can be easily extended as per organization's needs.

Additional ansible examples, including the use of roles, can be found here:
[GitHub: adealdag/aci-ansible-webinar](https://github.com/adealdag/aci-ansible-webinar)

Especifically, on demo07, another use case for ansible roles can be found.



