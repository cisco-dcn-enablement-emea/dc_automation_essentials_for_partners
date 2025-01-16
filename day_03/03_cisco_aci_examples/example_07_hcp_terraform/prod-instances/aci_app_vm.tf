#
# Local variables
#
locals {
  aci_portgroups = {
    for epg_key, epg_value in data.tfe_outputs.prod-networks.values.networks_epg_dn : epg_key => join("|", regex("uni/tn-([^/]+)/ap-([^/]+)/epg-([^/]+)", epg_value))
  }
}

#
# VM Folder
#
data "vsphere_datacenter" "vsphere_dc" {
  for_each = var.vm_location

  name = each.value.vsphere_dc
}

resource "vsphere_folder" "folder" {
  for_each = var.vm_location

  path          = each.value.vsphere_vm_folder
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.vsphere_dc[each.key].id
}

#
# VM Instances
#
module "vm" {
  # source   = "github.com/adealdag/terraform-vsphere-vm-from-template?ref=v0.1.0"
  source   = "app.terraform.io/spain-cn-lab/vm-from-template/vsphere"
  version  = "0.1.0"
  for_each = var.vm_list

  vsphere_dc         = var.vm_location[each.value.vm_location_key].vsphere_dc
  vsphere_ds         = var.vm_location[each.value.vm_location_key].vsphere_ds
  cluster            = var.vm_location[each.value.vm_location_key].vsphere_cluster
  host               = null
  vm_template        = each.value.vm_template
  vm_name            = each.value.vm_name
  vm_domain          = var.vm_location[each.value.vm_location_key].domain_name
  vm_folder          = var.vm_location[each.value.vm_location_key].vsphere_vm_folder
  vm_network_ip      = each.value.vm_network_ip
  vm_network_mask    = each.value.vm_network_mask
  vm_network_gateway = each.value.vm_network_gateway
  vm_portgroup       = local.aci_portgroups[each.value.vm_epg_name]
}
