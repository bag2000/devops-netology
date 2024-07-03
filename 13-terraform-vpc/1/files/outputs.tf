output "public-vm-ip" {
  value = yandex_compute_instance.public-vm.network_interface[0].nat_ip_address
}

output "private-vm-ip" {
  value = yandex_compute_instance.private-vm.network_interface[0].ip_address
}