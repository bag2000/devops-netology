resource "yandex_compute_disk" "default" {
    count    = var.disk_count
    name     = "disk-${count.index + 1}"
    type     = var.disk_type
    size     = var.disk_size
}

resource "yandex_compute_instance" "storage" {
    name        = var.storage_name
    platform_id = var.each_vm[0]["platform_id"]
    depends_on = [ yandex_compute_instance.db ]
    resources {
        cores         = var.each_vm[0]["cpu"]
        memory        = var.each_vm[0]["ram"]
        core_fraction = var.each_vm[0]["core_fraction"]
    }
    boot_disk {
        initialize_params {
            image_id = data.yandex_compute_image.ubuntu.image_id
            size = var.each_vm[0]["disk"]
        }
    }
    dynamic "secondary_disk" {
        for_each = yandex_compute_disk.default
    
        content {
            disk_id = secondary_disk.value.id
        }
  }

    scheduling_policy {
        preemptible = var.each_vm[0]["preemptibl"]
    }
    network_interface {
        subnet_id = yandex_vpc_subnet.develop.id
        nat       = var.each_vm[0]["nat"]
        security_group_ids = [yandex_vpc_security_group.example.id]
    }
    metadata = {
        serial-port-enable = var.each_vm[0]["serial_port"]
        ssh-keys           = "${var.each_vm[0]["username"]}:${local.ssh_pub_key}"
    }
}