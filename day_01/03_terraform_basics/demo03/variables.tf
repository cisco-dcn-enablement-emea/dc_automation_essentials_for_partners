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
    unicast_routing = string
    unk_ucast = string
  }))
  default = {
    default_bd = {
      name = "default"
      arp_flood = "yes"
      unicast_routing = "yes"
      unk_ucast = "proxy"
    }
  }
}