tenant_name = "demo_prod_tn"
vrf_name = "prod_vrf"
bridge_domains = {
    bd01 = {
        name = "192.168.1.0_24_bd"
        arp_flood = "yes"
        unicast_routing = "yes"
        unk_ucast = "proxy"
    },
    bd02 = {
        name = "192.168.2.0_24_bd"
        arp_flood = "yes"
        unicast_routing = "yes"
        unk_ucast = "proxy"
    }
}
