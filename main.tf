data "openstack_networking_network_v2" "project" {
  name = var.project_network
}

resource "openstack_compute_keypair_v2" "web" {
  name       = "${var.name_prefix}-key"
  public_key = file(pathexpand(var.ssh_public_key_path))
}

resource "openstack_networking_secgroup_v2" "web" {
  name        = "${var.name_prefix}-web-sg"
  description = "SSH from my IP, HTTP from anywhere"
}

resource "openstack_networking_secgroup_rule_v2" "ssh" {
  security_group_id = openstack_networking_secgroup_v2.web.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.ssh_allowed_cidr
}

resource "openstack_networking_secgroup_rule_v2" "http" {
  security_group_id = openstack_networking_secgroup_v2.web.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
}

resource "openstack_networking_port_v2" "web" {
  name               = "${var.name_prefix}-port"
  network_id         = data.openstack_networking_network_v2.project.id
  admin_state_up     = true
  security_group_ids = [openstack_networking_secgroup_v2.web.id]
}

resource "openstack_compute_instance_v2" "web" {
  name        = "${var.name_prefix}-vm"
  image_name  = var.image_name
  flavor_name = var.flavor_name
  key_pair    = openstack_compute_keypair_v2.web.name

  user_data = replace(templatefile("${path.module}/cloud-init.yaml", {
    student_name = var.student_name
    page_message = var.page_message
  }), "\r\n", "\n")

  network {
    port = openstack_networking_port_v2.web.id
  }
}

resource "openstack_networking_floatingip_v2" "web" {
  pool    = "public"
  port_id = openstack_networking_port_v2.web.id
}