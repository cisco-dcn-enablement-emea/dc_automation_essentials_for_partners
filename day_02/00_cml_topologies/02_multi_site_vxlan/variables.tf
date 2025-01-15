variable "address" {
  description = "CML controller address"
  type        = string
}

variable "username" {
  description = "cml2 username"
  type        = string
}

variable "password" {
  description = "cml2 password"
  type        = string
  sensitive   = true
}

variable "topology_name" {
  description = "YAML file to import"
  type        = string
}

variable "state" {
  description = "Set the initial node state. By default they are all powered on"
  type        = string
  default     = "STARTED"
}

variable "configuration_variables" {
  type = object({
    device_gateway    = string
    spine_1_ip        = string
    spine_2_ip        = string
    spine_3_ip        = string
    spine_4_ip        = string
    bordergw_1_ip       = string
    bordergw_2_ip       = string
    bordergw_3_ip       = string
    bordergw_4_ip       = string
    leaf_1_ip         = string
    leaf_2_ip         = string
    leaf_3_ip         = string
    leaf_4_ip         = string
    leaf_5_ip         = string
    leaf_6_ip         = string
    isn_1_ip         = string
    isn_2_ip         = string
    isn_3_ip         = string
    isn_4_ip         = string
    isn_5_ip         = string
    core_1_ip         = string
    image_definition  = optional(string, "null")
    management_bridge = string
    device_password   = string
  })
}
