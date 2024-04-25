# Set credentials for vSphere provider
# export VSPHERE_USER=""
# export VSPHERE_PASSWORD=""
# export VSPHERE_SERVER=""
provider "vsphere" {
  # Self-signed cert for now
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "technis"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "local"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = "gold"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "host" {
  name          = "core.technis.net"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = "templates/debian12"
  datacenter_id = data.vsphere_datacenter.dc.id
}

locals {
  vms = {
    "watchtower" = { mac_addr = "74:65:63:68:6E:04" },
  }
}

resource "vsphere_virtual_machine" "vm" {
  for_each = local.vms

  name             = each.key
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus             = 16
  num_cores_per_socket = 16
  memory               = 32768
  guest_id             = "debian11_64Guest"

  # GPU passthrough
  memory_reservation = 32768
  memory_reservation_locked_to_max = true
  host_system_id = data.vsphere_host.host.id
  pci_device_id = ["0000:82:00.0"]
  extra_config = {
      "disk.EnableUUID"             = "true"
      "hypervisor.cpuid.v0"         = "false"
      "pciPassthru.64bitMMIOSizeGB" = "32"
      "pciPassthru.use64bitMMIO"    = "true"
  }

  network_interface {
    network_id     = data.vsphere_network.network.id
    use_static_mac = true
    mac_address    = each.value.mac_addr
  }

  disk {
    label            = "disk0"
    size             = 500
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }
}
