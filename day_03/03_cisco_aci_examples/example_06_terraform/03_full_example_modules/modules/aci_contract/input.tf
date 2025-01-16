variable "name" {
  type = string
}

variable "tenant_dn" {
  type        = string
  description = "Distinguised Name of the parent tenant"
}

variable "scope" {
  type = string
  description = "Scope of the contract. Possible values are global, tenant, application-profile and context"
}

variable "subjects" {
    type = map(object({
      name        = string
      filters_dn = list(string)
    }))
    description = "Contract subjects. Every subject contains a list of filters distinguished names (DN) used in that subject"
}