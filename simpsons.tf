terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "2.0.2"
    }
  }
}

provider "vsphere" {
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"
  vsphere_server = "10.31.50.52"
  # If you have a self-signed cert
  allow_unverified_ssl = true


}  

data "vsphere_datacenter" "dc" {
  name = "${var.vsphere_datacenter}"
}

data "vsphere_host" "hosts" {
  name = "${var.vsphere_host}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_datacenter" "temp" {
  name = "${var.vsphere_datacenter_temp}"
}

data "vsphere_datastore" "datastore" {
  name          = "${var.vm_datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

  data "vsphere_resource_pool" "pool" {
  name          = "${var.vsphere_host}/Resources"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "${var.vm_network}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "${var.vmtemp}"
  datacenter_id = "${data.vsphere_datacenter.temp.id}"
}

resource "vsphere_virtual_machine" "vm" {
    name             = "${var.vm_name}"
    resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
    datastore_id     = "${data.vsphere_datastore.datastore.id}"
    wait_for_guest_net_timeout = 5
    wait_for_guest_ip_timeout  = 5
    num_cpus = "${var.vm_cpu}"
    memory   = "${var.vm_ram}"
    guest_id = "${data.vsphere_virtual_machine.template.guest_id}"
    scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"

    network_interface {
      network_id   = "${data.vsphere_network.network.id}"
      adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
    }

    disk {
      label            = "disk0"
      size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
      eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
      thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
    }
   
   disk {
     label            = "disk1"
     size             = "${data.vsphere_virtual_machine.template.disks.1.size}"
     eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.1.eagerly_scrub}"
     thin_provisioned = "${data.vsphere_virtual_machine.template.disks.1.thin_provisioned}"
     unit_number = 1
    } 

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
    timeout =180
          customize {
        timeout =60
        windows_options {
             computer_name = "${var.vm_name}"
             admin_password = "${var.local_adminpass}"
             join_domain      = "${var.windomain}"
             domain_admin_user = "${var.domain_admin_user}"
             domain_admin_password = "${var.domain_admin_password}" 
         }
        network_interface {}
      }
    }
  }

   output "my_ip_address" {
   value = "${vsphere_virtual_machine.vm.default_ip_address}"
}
