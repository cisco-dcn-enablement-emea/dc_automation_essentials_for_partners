# Variables file
# --

variable "tenant_name" {
  default = "demo_tn"
}

variable "vrf_name" {
  default = "main_vrf"
}

variable "bridge_domains" {
  type = map(object({
    name = string
    arp_flood = string
    type = string
    gateway = string
    scope = list(string)
  }))
  default = {
    default_bd = {
      name = "default"
      arp_flood = "yes"
      type = "L3"
      gateway = "192.168.1.1/24"
      scope = ["private"]
    }
  }
}