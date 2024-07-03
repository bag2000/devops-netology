resource "yandex_vpc_network" "netology" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "public" {
  name           = var.public_subnet_name
  zone           = var.zone_a
  network_id     = yandex_vpc_network.netology.id
  v4_cidr_blocks = var.public_cidr
}

resource "yandex_vpc_subnet" "private" {
  name           = var.private_subnet_name
  zone           = var.zone_a
  network_id     = yandex_vpc_network.netology.id
  v4_cidr_blocks = var.private_cidr
  route_table_id = yandex_vpc_route_table.private-rt.id
}

resource "yandex_vpc_gateway" "egress-gateway" {
  name = var.private_egress_gw_name
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "private-rt" {
  network_id = yandex_vpc_network.netology.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.egress-gateway.id
  }
}