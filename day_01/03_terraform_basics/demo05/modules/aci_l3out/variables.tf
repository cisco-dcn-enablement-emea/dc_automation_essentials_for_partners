variable "tenant_id" { }

variable "name" { }

variable "vrf_id" { }

variable "l3_ext_domain_id" { }

variable "nodes" {
  type = map(object({
    pod_id = string
    node_id = string
    rtr_id = string
    rtr_id_loopback = string
  }))
}

variable "paths" {
  type = map(object({
    pod_id = string
    node_id = string
    port_id = string
    ip_addr  = string
    mode = string
    mtu  = string
  }))
}

variable "bgp_peers" {
  type = map(object({
    peer_addr = string
    peer_asn = string
    local_asn = string
  }))
}

variable "external_epgs" {
  type = map(object({
    name = string
    prefGrp = string
    provided_contracts = list(string)
    consumed_contracts = list(string)
    subnets = map(object({
      ip = string
      scope = list(string)
    }))
  }))
}


