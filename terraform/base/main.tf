terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}
provider "yandex" {
  zone = var.cloud_zone
  service_account_key_file = "H:\\Downloads\\authorized_key.json"
  cloud_id = var.cloud_id
  folder_id = var.folder_id
}

resource "yandex_compute_instance" "vm" {
  count = var.count_srvs
  name = "server-${count.index}"

  resources {
    cores  = var.srv_cores
    memory = var.srv_memory
  }

  boot_disk {
    initialize_params {
      image_id = var.os_id
    }
  }
  
  metadata = {
    user-data = "${file("./secret.user.yml")}"
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.net.id}"
	  nat = true
    security_group_ids = [yandex_vpc_security_group.vm.id]
    nat_ip_address = yandex_vpc_address.addr.external_ipv4_address[0].address
  }

}

resource "yandex_vpc_network" "net" {}

resource "yandex_vpc_subnet" "net" {
  network_id     = "${yandex_vpc_network.net.id}"
  v4_cidr_blocks = ["10.5.0.0/24"]
}

resource "yandex_vpc_address" "addr" {
  name = "vm-adress"
  external_ipv4_address {
    zone_id = var.cloud_zone
  }
}

resource "yandex_vpc_security_group" "vm" {
  name        = "vm-security-group"
  description = "Правила группы разрешают подключение к сервисам из интернета. Примените правила только для групп узлов."
  network_id  = "${yandex_vpc_network.net.id}"

  dynamic "ingress" {
    for_each = var.allow_ports
    
    content {
      protocol       = "TCP"
      description    = "Правило разрешает входящий трафик из интернета на диапазон портов NodePort. Добавьте или измените порты на нужные вам."
      v4_cidr_blocks = ["0.0.0.0/0"]
      from_port      = ingress.value
      to_port        = ingress.value
    }
  }

  egress {
    protocol       = "ANY"
    description    = "Правило разрешает весь исходящий трафик. Узлы могут связаться с Yandex Container Registry, Object Storage, Docker Hub и т. д."
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}