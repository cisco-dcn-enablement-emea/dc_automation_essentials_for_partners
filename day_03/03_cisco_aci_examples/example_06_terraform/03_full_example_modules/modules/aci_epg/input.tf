variable "name" {
  type = string
}

variable "name_alias" {
  type = string
  default = ""
}

variable "pref_gr_memb" {
  type        = string
  description = "Defines if EPG belongs to the VRF preferred group. Possible values are include or exclude"
  default     = "exclude"
}

variable "app_profile_dn" {
  type = string
  description = "Distinguished Name (DN) of the parent application profile"
}

variable "bridge_domain_dn" {
  type = string
  description = "Bride Domain DN the EPG is attached to"
}

variable "associated_domains_dn" {
  type        = list(string)
  description = "Domains that are attached to the EPG. List of distiguished names (DN)"
  default     = []
}

variable "cons_contracts_dn" {
  type        = list(string)
  description = "Contracts consumed by EPG. List of distinguished names (DN)"
  default     = []
}

variable "prov_contracts_dn" {
  type        = list(string)
  description = "Contracts provided by EPG. List of distinguished names (DN)"
  default     = []
}

