# Define required providers
terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
  }
}

# Configure the OpenStack Provider
provider "openstack" {
  user_name="admin"
  password="God"
  auth_url="http://192.168.1.139/identity/"
  tenant_name="home"
}

resource "openstack_networking_network_v2" "service" {
  name           = "service"
  admin_state_up = "true"
  shared = "true"
}

resource "openstack_networking_subnet_v2" "service" {
  name       = "service"
  network_id = "${openstack_networking_network_v2.service.id}"
  cidr       = "10.0.1.0/24"
  ip_version = 4
}

resource "openstack_networking_network_v2" "intra" {
  name           = "intra"
  admin_state_up = "true"
  external = "true"
  segments {
    physical_network = "public"
    network_type = "flat"
  }
}

resource "openstack_networking_subnet_v2" "intra" {
  name       = "intra"
  network_id = "${openstack_networking_network_v2.intra.id}"
  cidr       = "192.168.1.224/27"
  ip_version = 4
  enable_dhcp = "true"
}
