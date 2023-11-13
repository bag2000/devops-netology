output "server_public_ip" {
  value = yandex_vpc_address.addr.external_ipv4_address[0].address
}

output "server_local_ip" {
  value = yandex_compute_instance.vm[0].network_interface[0].ip_address
}