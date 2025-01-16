# Schema and templates
variable "schema_id" {
  description = "Schema ID"
}

variable "template_stretched_base" {
  description = "Name of the stretched template"
}

variable "template_stretched" {
  description = "Name of the stretched template"
}

variable "template_local_site1" {
  description = "Name of the template local to site 1"
}

variable "template_local_site2" {
  description = "Name of the template local to site 2"
}

# Sites
variable "site1_id" {
  description = "Site ID for Cisco ACI Site 1"
}

variable "site2_id" {
  description = "Site ID for Cisco ACI Site 2"
}

# Domains
variable "vmm_site1" {
  description = "DN of VMM domain in ACI Site 1"
}

variable "vmm_site2" {
  description = "DN of VMM domain in ACI Site 2"
}

# L3Out
variable "l3out_name" {
  description = "Name of the L3Out"
}
