##Compute Variables
vsphere_library        = "VM-Templates"
vsphere_vm_folder_type = "vm"

vsphere_port_group = {
  dev = {
    web = "nsx-web"
    app = "nsx-app"
    db  = "nsx-db"
  }
  tes = {
    web = "nsx-web"
    app = "nsx-app"
    db  = "nsx-db"
  }
  prd = {
    web = "nsx-web-prod"
    app = "nsx-app-prod"
    db  = "nsx-db"
  }
}

#Common tags
common_environment_tags = ["production", "test", "development"]
common_nsx_tier_tags    = ["web", "app", "data"]
environment-tag = {
  dev = "development"
  tes = "test"
  prd = "production"
}
##Other Variables
application_name = "application-x"
billing_code     = "SMT2021-1203"  #["SMT2021-1203", "SMT2021"]
project          = "smt-programme" #["smt-programme", "smt-project-x"]


#VM Variables
virtualmachine = {
  web = {
    #Node1
    computer_name = "web-01"
    ipv4_address  = "10.50.10.10"
    #Node2
    a_computer_name = "web-02"
    a_ipv4_address  = "10.50.10.11"
    #Common
    num_cpus                = "1"
    num_cores_per_socket    = "1"
    memory                  = "1024"
    folder                  = "web"
    vsphere_template        = "lin-pho-4"
    guest_id                = "vmwarePhoton64Guest"
    firmware                = "bios"
    hardware_version        = 19
    annotation              = "Built using Terraform"
    adapter_type            = "vmxnet3"
    ipv4_netmask            = 24
    ipv4_gateway            = "10.50.10.254"
    dns_server_list         = ["10.200.15.1"]
    join_domain             = "smt.com"
    scsi_controller_count   = 1
    scsi_type               = "pvscsi"
    disk_size_0             = 25
    disk_label_0            = "Disk0.vmdk"
    disk_eagerly_scrub_0    = false
    disk_thin_provisioned_0 = true
    disk_unit_number_0      = 0
  }
  app = {
    #Node1
    computer_name = "app-01"
    ipv4_address  = "10.50.20.10"
    #Node2
    a_computer_name = "app-02"
    a_ipv4_address  = "10.50.20.11"
    #Common
    num_cpus                = "1"
    num_cores_per_socket    = "1"
    memory                  = "1024"
    folder                  = "web"
    vsphere_template        = "lin-pho-4"
    guest_id                = "vmwarePhoton64Guest"
    firmware                = "bios"
    hardware_version        = 19
    annotation              = "Built using Terraform"
    adapter_type            = "vmxnet3"
    ipv4_netmask            = 24
    ipv4_gateway            = "10.50.20.254"
    dns_server_list         = ["10.200.15.1"]
    join_domain             = "smt.com"
    scsi_controller_count   = 1
    scsi_type               = "pvscsi"
    disk_size_0             = 25
    disk_label_0            = "Disk0.vmdk"
    disk_eagerly_scrub_0    = false
    disk_thin_provisioned_0 = true
    disk_unit_number_0      = 0

  }
  db = {
    #Node1
    computer_name = "db-01"
    ipv4_address  = "10.50.30.10"
    #Node1
    a_computer_name = "db-02"
    a_ipv4_address  = "10.50.30.11"
    #Common
    num_cpus                = "1"
    num_cores_per_socket    = "1"
    memory                  = "1024"
    folder                  = "web"
    vsphere_template        = "lin-pho-4"
    guest_id                = "vmwarePhoton64Guest"
    firmware                = "bios"
    hardware_version        = 19
    annotation              = "Built using Terraform"
    adapter_type            = "vmxnet3"
    ipv4_netmask            = 24
    ipv4_gateway            = "10.50.30.254"
    dns_server_list         = ["10.200.15.1"]
    join_domain             = "smt.com"
    scsi_controller_count   = 1
    scsi_type               = "pvscsi"
    disk_size_0             = 25
    disk_label_0            = "Disk0.vmdk"
    disk_eagerly_scrub_0    = false
    disk_thin_provisioned_0 = true
    disk_unit_number_0      = 0

  }
}
