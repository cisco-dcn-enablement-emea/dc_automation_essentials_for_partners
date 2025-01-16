variable "tenant_name" {
  description = "Name of the tenant where the app infra for the project will be created"
  type        = string
}

variable "vrf_name" {
  description = "Name of the VRF where the app infra for the project will be created"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "project_subnet" {
  description = "Subnet for the project, in CIDR format: x.x.x.x/y"
  type        = string
}

variable "project_subnet_scope" {
  description = "Subnet scope for the project"
  type        = string
  validation {
    condition     = can(regex("^(public|private)$", var.project_subnet_scope))
    error_message = "Subnet scope must be either 'public' or 'private'"
  }
}

variable "project_open_ports" {
  description = "Open ports from the outside to the project's frontend tier"
  type        = list(string)
}

