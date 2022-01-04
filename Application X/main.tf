
## Data Gathering
#Datacenter
data "vsphere_datacenter" "datacenter" {
  name = var.vsphere_datacenter
}
#Datastore
data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}
#Cluster
data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_compute_cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}
#PortGroups
data "vsphere_network" "web-network" {
  name          = var.vsphere_port_group[terraform.workspace].web
  datacenter_id = data.vsphere_datacenter.datacenter.id
}
data "vsphere_network" "app-network" {
  name          = var.vsphere_port_group[terraform.workspace].app
  datacenter_id = data.vsphere_datacenter.datacenter.id
}
data "vsphere_network" "db-network" {
  name          = var.vsphere_port_group[terraform.workspace].db
  datacenter_id = data.vsphere_datacenter.datacenter.id
}
data "vsphere_content_library" "library" {
  name = var.vsphere_library
}

##Build
#Build Application vSphere Folders

resource "vsphere_folder" "environment-folder" {
  path          = "applications/${var.application_name}"
  type          = var.vsphere_vm_folder_type
  datacenter_id = data.vsphere_datacenter.datacenter.id
}
resource "vsphere_folder" "child-environment-folder" {
  path          = "${vsphere_folder.environment-folder.path}/${terraform.workspace}"
  type          = var.vsphere_vm_folder_type
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

#Create Tags
resource "vsphere_tag" "billing-code-tag" {
  #for_each    = toset(var.billing_code)
  #name        = each.key
  name        = var.billing_code
  category_id = vsphere_tag_category.category-billing-code.id
  description = "Managed by Terraform"
}
resource "vsphere_tag" "project-tag" {
  #for_each    = toset(var.project)
  #name        = each.key
  name        = var.project
  category_id = vsphere_tag_category.category-project.id
  description = "Managed by Terraform"
}
#Get Tags
data "vsphere_tag" "environment-tag" {
  name        = var.environment-tag[terraform.workspace]
  category_id = vsphere_tag_category.category-environment.id
  depends_on = [vsphere_tag.environment-tags

  ]
}

#Build Web Servers
data "vsphere_tag" "nsx-web-tier-tags" {
  name        = "web"
  category_id = vsphere_tag_category.category-nsx-tier.id
  depends_on  = [vsphere_tag.nsx-tier-tags]
}
resource "vsphere_folder" "web-tier-folder" {
  path          = "${vsphere_folder.child-environment-folder.path}/${var.virtualmachine.web.folder}"
  type          = var.vsphere_vm_folder_type
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_content_library_item" "web-template" {
  name       = var.virtualmachine.web.vsphere_template
  library_id = data.vsphere_content_library.library.id
  type       = "OVF"
}

resource "vsphere_virtual_machine" "web-01" {
  name             = "vm-${terraform.workspace}-${var.virtualmachine.web.computer_name}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus             = var.virtualmachine.web.num_cpus
  num_cores_per_socket = var.virtualmachine.web.num_cores_per_socket
  memory               = var.virtualmachine.web.memory
  folder               = vsphere_folder.web-tier-folder.path
  guest_id             = var.virtualmachine.web.guest_id
  firmware             = var.virtualmachine.web.firmware
  hardware_version     = var.virtualmachine.web.hardware_version
  network_interface {
    network_id   = data.vsphere_network.web-network.id
    adapter_type = var.virtualmachine.web.adapter_type
  }
  clone {
    template_uuid = data.vsphere_content_library_item.web-template.id
    timeout       = 60
    customize {
      timeout = 30
      linux_options {
        host_name = "vm-${terraform.workspace}-${var.virtualmachine.web.computer_name}"
        domain    = var.virtualmachine.web.join_domain
      }
      network_interface {
        ipv4_address = var.virtualmachine.web.ipv4_address
        ipv4_netmask = var.virtualmachine.web.ipv4_netmask
      }
      ipv4_gateway    = var.virtualmachine.web.ipv4_gateway
      dns_server_list = var.virtualmachine.web.dns_server_list
      dns_suffix_list = [var.virtualmachine.web.join_domain]
    }
  }
  scsi_controller_count = var.virtualmachine.web.scsi_controller_count
  scsi_type             = var.virtualmachine.web.scsi_type
  disk {
    size             = var.virtualmachine.web.disk_size_0
    label            = var.virtualmachine.web.disk_label_0
    eagerly_scrub    = var.virtualmachine.web.disk_eagerly_scrub_0
    thin_provisioned = var.virtualmachine.web.disk_thin_provisioned_0
    unit_number      = var.virtualmachine.web.disk_unit_number_0
  }
  tags = [
    vsphere_tag.billing-code-tag.id,
    vsphere_tag.project-tag.id,
    data.vsphere_tag.environment-tag.id,
    data.vsphere_tag.nsx-web-tier-tags.id,
  ]

}
resource "vsphere_virtual_machine" "web-02" {
  name             = "vm-${terraform.workspace}-${var.virtualmachine.web.a_computer_name}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus             = var.virtualmachine.web.num_cpus
  num_cores_per_socket = var.virtualmachine.web.num_cores_per_socket
  memory               = var.virtualmachine.web.memory
  folder               = vsphere_folder.web-tier-folder.path
  guest_id             = var.virtualmachine.web.guest_id
  firmware             = var.virtualmachine.web.firmware
  hardware_version     = var.virtualmachine.web.hardware_version
  network_interface {
    network_id   = data.vsphere_network.web-network.id
    adapter_type = var.virtualmachine.web.adapter_type
  }
  clone {
    template_uuid = data.vsphere_content_library_item.web-template.id
    timeout       = 60
    customize {
      timeout = 30
      linux_options {
        host_name = "vm-${terraform.workspace}-${var.virtualmachine.web.a_computer_name}"
        domain    = var.virtualmachine.web.join_domain
      }
      network_interface {
        ipv4_address = var.virtualmachine.web.a_ipv4_address
        ipv4_netmask = var.virtualmachine.web.ipv4_netmask
      }
      ipv4_gateway    = var.virtualmachine.web.ipv4_gateway
      dns_server_list = var.virtualmachine.web.dns_server_list
      dns_suffix_list = [var.virtualmachine.web.join_domain]
    }
  }
  scsi_controller_count = var.virtualmachine.web.scsi_controller_count
  scsi_type             = var.virtualmachine.web.scsi_type
  disk {
    size             = var.virtualmachine.web.disk_size_0
    label            = var.virtualmachine.web.disk_label_0
    eagerly_scrub    = var.virtualmachine.web.disk_eagerly_scrub_0
    thin_provisioned = var.virtualmachine.web.disk_thin_provisioned_0
    unit_number      = var.virtualmachine.web.disk_unit_number_0
  }
  tags = [
    vsphere_tag.billing-code-tag.id,
    vsphere_tag.project-tag.id,
    data.vsphere_tag.environment-tag.id,
    data.vsphere_tag.nsx-web-tier-tags.id,
  ]

}

#Build App Servers
data "vsphere_tag" "nsx-app-tier-tags" {
  name        = "app"
  category_id = vsphere_tag_category.category-nsx-tier.id
  depends_on  = [vsphere_tag.nsx-tier-tags]
}
resource "vsphere_folder" "app-tier-folder" {
  path          = "${vsphere_folder.child-environment-folder.path}/${var.virtualmachine.app.folder}"
  type          = var.vsphere_vm_folder_type
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_content_library_item" "app-template" {
  name       = var.virtualmachine.app.vsphere_template
  library_id = data.vsphere_content_library.library.id
  type       = "OVF"
}

resource "vsphere_virtual_machine" "app-01" {
  name             = "vm-${terraform.workspace}-${var.virtualmachine.app.computer_name}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus             = var.virtualmachine.app.num_cpus
  num_cores_per_socket = var.virtualmachine.app.num_cores_per_socket
  memory               = var.virtualmachine.app.memory
  folder               = vsphere_folder.app-tier-folder.path
  guest_id             = var.virtualmachine.app.guest_id
  firmware             = var.virtualmachine.app.firmware
  hardware_version     = var.virtualmachine.app.hardware_version
  network_interface {
    network_id   = data.vsphere_network.app-network.id
    adapter_type = var.virtualmachine.app.adapter_type
  }
  clone {
    template_uuid = data.vsphere_content_library_item.app-template.id
    timeout       = 60
    customize {
      timeout = 30
      linux_options {
        host_name = "vm-${terraform.workspace}-${var.virtualmachine.app.computer_name}"
        domain    = var.virtualmachine.app.join_domain
      }
      network_interface {
        ipv4_address = var.virtualmachine.app.ipv4_address
        ipv4_netmask = var.virtualmachine.app.ipv4_netmask
      }
      ipv4_gateway    = var.virtualmachine.app.ipv4_gateway
      dns_server_list = var.virtualmachine.app.dns_server_list
      dns_suffix_list = [var.virtualmachine.app.join_domain]
    }
  }
  scsi_controller_count = var.virtualmachine.app.scsi_controller_count
  scsi_type             = var.virtualmachine.app.scsi_type
  disk {
    size             = var.virtualmachine.app.disk_size_0
    label            = var.virtualmachine.app.disk_label_0
    eagerly_scrub    = var.virtualmachine.app.disk_eagerly_scrub_0
    thin_provisioned = var.virtualmachine.app.disk_thin_provisioned_0
    unit_number      = var.virtualmachine.app.disk_unit_number_0
  }
  tags = [
    vsphere_tag.billing-code-tag.id,
    vsphere_tag.project-tag.id,
    data.vsphere_tag.environment-tag.id,
    data.vsphere_tag.nsx-app-tier-tags.id,
  ]

}
resource "vsphere_virtual_machine" "app-02" {
  name             = "vm-${terraform.workspace}-${var.virtualmachine.app.a_computer_name}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus             = var.virtualmachine.app.num_cpus
  num_cores_per_socket = var.virtualmachine.app.num_cores_per_socket
  memory               = var.virtualmachine.app.memory
  folder               = vsphere_folder.app-tier-folder.path
  guest_id             = var.virtualmachine.app.guest_id
  firmware             = var.virtualmachine.app.firmware
  hardware_version     = var.virtualmachine.app.hardware_version
  network_interface {
    network_id   = data.vsphere_network.app-network.id
    adapter_type = var.virtualmachine.app.adapter_type
  }
  clone {
    template_uuid = data.vsphere_content_library_item.app-template.id
    timeout       = 60
    customize {
      timeout = 30
      linux_options {
        host_name = "vm-${terraform.workspace}-${var.virtualmachine.app.a_computer_name}"
        domain    = var.virtualmachine.app.join_domain
      }
      network_interface {
        ipv4_address = var.virtualmachine.app.a_ipv4_address
        ipv4_netmask = var.virtualmachine.app.ipv4_netmask
      }
      ipv4_gateway    = var.virtualmachine.app.ipv4_gateway
      dns_server_list = var.virtualmachine.app.dns_server_list
      dns_suffix_list = [var.virtualmachine.app.join_domain]
    }
  }
  scsi_controller_count = var.virtualmachine.app.scsi_controller_count
  scsi_type             = var.virtualmachine.app.scsi_type
  disk {
    size             = var.virtualmachine.app.disk_size_0
    label            = var.virtualmachine.app.disk_label_0
    eagerly_scrub    = var.virtualmachine.app.disk_eagerly_scrub_0
    thin_provisioned = var.virtualmachine.app.disk_thin_provisioned_0
    unit_number      = var.virtualmachine.app.disk_unit_number_0
  }
  tags = [
    vsphere_tag.billing-code-tag.id,
    vsphere_tag.project-tag.id,
    data.vsphere_tag.environment-tag.id,
    data.vsphere_tag.nsx-app-tier-tags.id,
  ]

}



#Build DB Servers
