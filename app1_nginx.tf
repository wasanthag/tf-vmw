## Configure the vSphere Provider
provider "vsphere" {
  vsphere_server       = var.vsphere_server
  user                 = var.vsphere_user
  password             = var.vsphere_password
  allow_unverified_ssl = true
}

## Build VM
data "vsphere_datacenter" "dc" {
  name = "Lab"
}

data "vsphere_datastore" "datastore" {
  name          = "vStorage1"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = "Nginx_Demo"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "mgmt_lan" {
  name          = "Management Network"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = "Appserver-1-Template"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "app1" {
  name             = "app1-vm"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus                  = 2
  memory                    = 2048
  wait_for_guest_ip_timeout = 10
  guest_id                  = "centos7_64Guest"
  nested_hv_enabled         = true

  network_interface {
    network_id   = data.vsphere_network.mgmt_lan.id
    adapter_type = "vmxnet3"
  }

  disk {
    size             = 20
    label            = "app1-disk"
    eagerly_scrub    = false
    thin_provisioned = false
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = "appserver1"
        domain    = "lab.local"
      }

      network_interface {
      }
    }
  }
}

