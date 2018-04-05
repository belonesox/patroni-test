data "vsphere_datacenter" "dc" {
  name = "${var.vsphere_dc}"
}

data "vsphere_datastore" "datastore" {
  name          = "${var.vm_datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "${var.vm_rpool}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "${var.vm_netlabel}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "${var.vm_temp}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

###############
# VM resource #
###############
resource "vsphere_virtual_machine" "vm" {
  count            = 3
  name             = "patroni-testing-0${count.index+1}"
  folder           = "${var.vm_folder}"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 4
  memory   = 8000

  # https://www.vmware.com/support/developer/converter-sdk/conv61_apireference/vim.vm.GuestOsDescriptor.GuestOsIdentifier.html
  guest_id = "centos64Guest"

  scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  disk {
    label = "disk0"

    size = "200"

    #size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
  }

  # Update hostname and reboot
  provisioner "remote-exec" {
    inline = [
      "echo password | sudo -S hostnamectl set-hostname ${self.name}",
      "parted -s /dev/sda mkpart primary ext2  32.2GB 100%",
      "parted -s /dev/sda set 3 lvm on",
      "pvcreate /dev/sda3",
      "vgextend centos /dev/sda3",
      "lvextend -l 100%FREE /dev/centos/root",
      "xfs_growfs /dev/mapper/centos-root",
      "reboot",
    ]

    # "reboot"

    connection {
      type     = "ssh"
      user     = "root"
      password = "password"
    }
  }
}
