terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

variable "private_key_path" {
  description = "Path to ssh private key, which would be used to access workers"
  default     = "D:\\GitProjects\\SSH Keys\\id_rsa"
}

locals {
  cloud_id = "b1g"
  folder_id = "b1g"
}

provider "yandex" {
  zone = "ru-central1-a"
  service_account_key_file = "H:\\Downloads\\authorized_key.json"
  cloud_id = local.cloud_id
  folder_id = local.folder_id
}

resource "yandex_compute_instance" "webserver" {

  # Что бы присвоить имя, нужно убрать count
  name = "webserver"
  zone = "ru-central1-a"

  metadata = {
    user-data = "${file("./meta.yml")}"
  }

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8nru7hnggqhs9mkqps"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.web.id}"
    nat = true
    security_group_ids = [yandex_vpc_security_group.webserver.id]
    nat_ip_address = yandex_vpc_address.addr.external_ipv4_address[0].address
  }

  provisioner "file" {
    source      = "./user_data.sh"
    destination = "/tmp/user_data.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/user_data.sh",
      "sudo /tmp/user_data.sh",
    ]
  }
    connection {
      type = "ssh"
      user = "adm2"
      private_key = file(var.private_key_path)
      host = self.network_interface[0].nat_ip_address
    }
}

resource "yandex_vpc_network" "web" {}

resource "yandex_vpc_subnet" "web" {
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.web.id}"
  v4_cidr_blocks = ["10.5.0.0/24"]
}

resource "yandex_vpc_address" "addr" {
  name = "vm-adress"
  external_ipv4_address {
    zone_id = "ru-central1-a"
  }
}

resource "yandex_vpc_security_group" "webserver" {
  name        = "webserver-security-group"
  description = "Правила группы разрешают подключение к сервисам из интернета. Примените правила только для групп узлов."
  network_id  = "${yandex_vpc_network.web.id}"

  ingress {
    protocol       = "TCP"
    description    = "Правило разрешает входящий трафик из интернета на диапазон портов NodePort. Добавьте или измените порты на нужные вам."
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 80
    to_port        = 80
  }

    ingress {
    protocol       = "TCP"
    description    = "Правило разрешает входящий трафик из интернета на диапазон портов NodePort. Добавьте или измените порты на нужные вам."
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 22
    to_port        = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "Правило разрешает входящий трафик из интернета на диапазон портов NodePort. Добавьте или измените порты на нужные вам."
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 443
    to_port        = 443
  }

  egress {
    protocol       = "ANY"
    description    = "Правило разрешает весь исходящий трафик. Узлы могут связаться с Yandex Container Registry, Object Storage, Docker Hub и т. д."
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}