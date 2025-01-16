variable "vsphere_server" {}
variable "vsphere_username" {}
variable "vsphere_password" {}

variable "vm_location" {
  type = map(object({
    vsphere_dc        = string
    vsphere_ds        = string
    vsphere_cluster   = string
    vsphere_vm_folder = string
    domain_name       = string
  }))
}

variable "vm_list" {
  type = map(object({
    vm_location_key    = string
    vm_template        = string
    vm_name            = string
    vm_network_ip      = string
    vm_network_mask    = number
    vm_network_gateway = string
    vm_epg_name        = string
  }))
}
