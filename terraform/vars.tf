variable "viuser" {}
variable "vipassword" {}

variable "viserver" {
  default = "vcenter-vmtl.office.custis.ru"
}

// default VM name in vSphere
variable "vsphere_dc" {
  default = "Office"
}

// default VM name in vSphere
variable "vm_name" {
  default = ""
}

// default VM hostname
variable "vm_hostname" {
  default = ""
}

variable "vm_folder" {
  default = "VMs"
}

// default Resource Pool
variable "vm_rpool" {
  default = "vmtl-n02.vsphere.local/Resources"
}

// default VM domain for guest customization
variable "vm_domain" {
  default = "local.domain"
}

// default datastore to deploy vmdk
variable "vm_datastore" {
  default = "vmtl-n02-local"
}

// default VM Template
variable "vm_temp" {
  default = "centos7"
}

//variable "vm_guestid" {
//  default = "centos64Guest"
//}

// map of the VM Network (vmdomain = "vmnetlabel")
variable "vm_netlabel" {
  default = "VLAN 215 TN Net"
}
