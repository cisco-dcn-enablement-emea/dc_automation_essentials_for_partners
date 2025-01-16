# Sites
variable "site1" {
  description = "Name of Cisco ACI Site 1"
}

variable "site2" {
  description = "Name of Cisco ACI Site 2"
}

# Domains
variable "vmm_site1" {
  description = "Name of VMM domain in ACI Site 1"
}

variable "vmm_site2" {
  description = "Name of VMM domain in ACI Site 2"
}

# L3Out
variable "l3out_name" {
  description = "Name of the L3Out"
}