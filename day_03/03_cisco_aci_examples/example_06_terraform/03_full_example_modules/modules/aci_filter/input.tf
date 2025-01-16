variable "name" {
  type = string
}

variable "tenant_dn" {
  type        = string
  description = "Distinguised Name of the parent tenant"
}

variable "filter_entries" {
    type = map(object({
      name        = string
      ether_t     = string
      prot        = string
      d_from_port = string
      d_to_port   = string
    }))
    description = "Filter entries. Map of objects"  
}