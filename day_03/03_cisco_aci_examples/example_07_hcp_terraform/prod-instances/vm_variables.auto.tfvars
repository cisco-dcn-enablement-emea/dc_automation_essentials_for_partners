vm_location = {
  "mdr1" = {
    domain_name       = "dcmdr.ciscolabs.com"
    vsphere_cluster   = "HX-C1"
    vsphere_dc        = "MDR1"
    vsphere_ds        = "HX-DS01"
    vsphere_vm_folder = "adealdag/tfc-iac-demo"
  },
  "mlg1" = {
    domain_name       = "dcmdr.ciscolabs.com"
    vsphere_cluster   = "UCS-C1"
    vsphere_dc        = "MLG1"
    vsphere_ds        = "UCS-C1-DS01"
    vsphere_vm_folder = "adealdag/tfc-iac-demo"
  }
}

vm_list = {
  "ngnix01" = {
    vm_location_key    = "mdr1"
    vm_template        = "nvt_v4"
    vm_name            = "vm-ngnix-01"
    vm_network_ip      = "192.168.1.101"
    vm_network_mask    = 24
    vm_network_gateway = "192.168.1.1"
    vm_epg_name        = "prod-fe-01"
  },
  "ngnix02" = {
    vm_location_key    = "mdr1"
    vm_template        = "nvt_v4"
    vm_name            = "vm-ngnix-02"
    vm_network_ip      = "192.168.1.102"
    vm_network_mask    = 24
    vm_network_gateway = "192.168.1.1"
    vm_epg_name        = "prod-fe-01"
  },
  "ngnix03" = {
    vm_location_key    = "mdr1"
    vm_template        = "nvt_v4"
    vm_name            = "vm-ngnix-03"
    vm_network_ip      = "192.168.1.103"
    vm_network_mask    = 24
    vm_network_gateway = "192.168.1.1"
    vm_epg_name        = "prod-fe-01"
  },
  "nodejs01" = {
    vm_location_key    = "mdr1"
    vm_template        = "nvt_v4"
    vm_name            = "vm-nodejs-01"
    vm_network_ip      = "192.168.2.121"
    vm_network_mask    = 24
    vm_network_gateway = "192.168.2.1"
    vm_epg_name        = "prod-be-01"
  },
  "nodejs02" = {
    vm_location_key    = "mdr1"
    vm_template        = "nvt_v4"
    vm_name            = "vm-nodejs-02"
    vm_network_ip      = "192.168.2.122"
    vm_network_mask    = 24
    vm_network_gateway = "192.168.2.1"
    vm_epg_name        = "prod-be-01"
  },
  "mariadb01" = {
    vm_location_key    = "mdr1"
    vm_template        = "nvt_v4"
    vm_name            = "vm-mariadb-01"
    vm_network_ip      = "192.168.3.131"
    vm_network_mask    = 24
    vm_network_gateway = "192.168.3.1"
    vm_epg_name        = "prod-db-01"
  },
  "mariadb02" = {
    vm_location_key    = "mdr1"
    vm_template        = "nvt_v4"
    vm_name            = "vm-mariadb-02"
    vm_network_ip      = "192.168.3.132"
    vm_network_mask    = 24
    vm_network_gateway = "192.168.3.1"
    vm_epg_name        = "prod-db-01"
  }
}
