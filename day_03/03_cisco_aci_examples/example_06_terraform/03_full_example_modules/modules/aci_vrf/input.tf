variable "name" {
  type = string
}

variable "pref_gr" {
  type        = string
  description = "Enables or disabled Preferred Groups at the VRF level. Possible values are enabled or disabled"
  default     = "disabled"
}

variable "vzany" {
  type = object({
    prov_contracts_dn = list(string)
    cons_contracts_dn = list(string)
  })
  description = "vzAny object that represents all EPGs in the VRF"
  default = {
    cons_contracts_dn = []
    prov_contracts_dn = []
  }
}

variable "tenant_dn" {
  type        = string
  description = "Distinguised Name of the parent tenant"
}
