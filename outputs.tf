output "public_ip" {
  description = "Public IP address of the VM"
  value       = openstack_networking_floatingip_v2.web.address
}

output "website_url" {
  description = "URL of the deployed website"
  value       = "http://${openstack_networking_floatingip_v2.web.address}"
}