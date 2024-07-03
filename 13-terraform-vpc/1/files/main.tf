resource "yandex_compute_instance" "public-vm" {
  name        = var.public_vm_name

  resources {
    cores         = var.vms_resources["public"]["cpu"]
    memory        = var.vms_resources["public"]["memory"]
    core_fraction = var.vms_resources["public"]["core_fraction"]
  }

  boot_disk {
    initialize_params {
      image_id = var.img_id
    }
  }

  scheduling_policy {
    preemptible = var.preemptible
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.public.id
    ip_address = var.public_vm_ip
    nat        = var.public_vm_nat
  }

  metadata = {
    serial-port-enable = var.vms_resources["meta"]["serial_port_enable"]
    ssh-keys           = "${var.vms_resources["meta"]["username"]}:${var.vms_ssh_root_key}"
  }

  connection {
      host        = yandex_compute_instance.public-vm.network_interface[0].nat_ip_address
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("/home/adm2/.ssh/id_ed25519")}"
      agent       = false
      timeout     = "300s"
  }

  provisioner "file" {
    source      = "~/.ssh/id_ed25519"
    destination = "/home/ubuntu/.ssh/id_ed25519"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 0600 /home/ubuntu/.ssh/id_ed25519",
    ]
  }
}

resource "yandex_compute_instance" "private-vm" {
  name        = var.private_vm_name

  resources {
    cores         = var.vms_resources["private"]["cpu"]
    memory        = var.vms_resources["private"]["memory"]
    core_fraction = var.vms_resources["private"]["core_fraction"]
  }

  boot_disk {
    initialize_params {
      image_id = var.img_id
    }
  }

  scheduling_policy {
    preemptible = var.preemptible
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.private.id
    nat        = var.private_vm_nat
  }

  metadata = {
    serial-port-enable = var.vms_resources["meta"]["serial_port_enable"]
    ssh-keys           = "${var.vms_resources["meta"]["username"]}:${var.vms_ssh_root_key}"
  }
}