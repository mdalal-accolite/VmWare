#====================#
# vCenter connection #
#====================#

variable "vsphere_user" {
  description = "vSphere user name"
   sensitive = true
}

variable "vsphere_password" {
  description = "vSphere password"
  sensitive = true
}

variable "vsphere_datacenter" {
  description = "vSphere datacenter"
}

variable "vsphere_host" {
  description = "vSphere Hosts"
}

variable "vm_datastore" {
  description = "vSphere datastore"
}

variable "vsphere_datacenter_temp" {
    description = "vSphere datacenter"
  }

variable "vm_cpu" {
  description = "Number of vCPU for the vSphere virtual machines"
}

variable "vm_ram" {
  description = "Amount of RAM for the vSphere virtual machines (example: 2048)"
}

variable "vmtemp" {
  description = "Name of the template available in the vSphere."
}

variable "vm_name" {
  description = "The name of the vSphere virtual machines and the hostname of the machine"
}

variable "local_adminpass" {
  description = "The administrator password for this virtual machine.(Required) when using join_windomain option."
}


variable "vm_network" {
  description = "Network used for the vSphere virtual machines"
}

variable "windomain" {
  description = "The domain to join for this virtual machine. One of this or workgroup must be included."
}

variable "domain_admin_user" {
  description = "Domain admin user to join the server to AD.(Required) when using join_windomain option."
}

variable "domain_admin_password" {
  description = "Doamin User pssword to join the server to AD.(Required) when using join_windomain option."
}


