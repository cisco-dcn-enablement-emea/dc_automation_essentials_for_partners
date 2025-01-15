variable "switch_host" {
  description = "IP address of the Nexus switch"
  type        = string
}

variable "switch_username" {
  description = "Username for Nexus switch"
  type        = string
}

variable "switch_password" {
  description = "Password for Nexus switch"
  type        = string
  sensitive   = true
}

variable "port_channel_id" {
  description = "ID of the Port-Channel"
  type        = number
}

variable "vlan_id" {
  description = "ID of the VLAN"
  type        = number
}

variable "vlan_name" {
  description = "Name of the VLAN"
  type        = string
}

variable "svi_ip" {
  description = "IP address for the SVI in CIDR format"
  type        = string
}

variable "vrf_name" {
  description = "Optional VRF name for the SVI"
  type        = string
  default     = "default"
}

variable "bgp_as_number" {
  description = "BGP autonomous system number"
  type        = number
}

variable "bgp_neighbor_ip" {
  description = "BGP neighbor IP address"
  type        = string
}

variable "bgp_remote_as" {
  description = "Remote AS number for BGP neighbor"
  type        = number
}

variable "physical_interface" {
  description = "Name of the physical interface for the subinterface"
  type        = string
}

variable "subinterface_id" {
  description = "ID of the subinterface"
  type        = number
}

variable "subinterface_ip" {
  description = "IP address for the subinterface in CIDR format"
  type        = string
}

variable "pc_physical_interfaces" {
  description = "List of physical interfaces to attach to the Port-Channel"
  type        = list(string)
}