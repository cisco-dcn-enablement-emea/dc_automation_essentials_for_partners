variable "name" {
  type = string
}

variable "type" {
  type        = string
  description = "Type of bridge domain. Other bridge domain settings will be calculated based on this attribute. Possible values are L2 and L3"
  default     = "L2"
  validation {
    condition     = (var.type == "L2" || var.type == "L3")
    error_message = "The type value must be either L2 or L3."
  }
}

variable "ip_addr" {
  type        = string
  description = "IP address and mask for the bridge domain subnet"
  default     = null
}

variable "scope" {
  type        = list(string)
  description = "Scope of bridge domain subnet. List of strings: possible values are public, private and shared"
  default     = ["private"]
}

variable "vrf_dn" {
  type        = string
  description = "Distinguished Name of the VRF associated to the bridge domain"
}

variable "associated_l3outs_dn" {
  type        = list(string)
  description = "Associated L3Outs to bridge domain. List of Distiguished Names"
  default = []
}

variable "tenant_dn" {
  type        = string
  description = "Distinguised Name of the parent tenant"
}
