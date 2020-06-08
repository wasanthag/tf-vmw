data "vsphere_virtual_machine" "win2019-template" {
  name          = "Win2019-Packer-Template"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "win2019-vm" {
  name             = "win2019-vm"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  count = 2

  scsi_type = data.vsphere_virtual_machine.win2019-template.scsi_type

  num_cpus                  = 4
  memory                    = 8192
  wait_for_guest_ip_timeout = 10
  guest_id = "windows9Server64Guest"

  network_interface {
    network_id   = data.vsphere_network.mgmt_lan.id
    adapter_type = "vmxnet3"
  }

  disk {
    size             = 40
    label            = "w2019-disk"
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.win2019-template.id


  }
}

