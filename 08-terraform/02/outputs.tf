output "web_public_ip" {
  value = yandex_compute_instance.platform.network_interface[0].nat_ip_address
}

output "db_public_ip" {
  value = yandex_compute_instance.platform2.network_interface[0].nat_ip_address
}