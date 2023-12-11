resource "yandex_compute_instance" "db" {
    for_each = {main = var.each_vm[0], replica = var.each_vm[1]}
    name        = "db-${each.value["vm_name"]}"
    platform_id = each.value["platform_id"]
    resources {
        cores         = each.value["cpu"]
        memory        = each.value["ram"]
        core_fraction = each.value["core_fraction"]
    }
    boot_disk {
        initialize_params {
            image_id = data.yandex_compute_image.ubuntu.image_id
            size = each.value["disk"]
        }
    }
    scheduling_policy {
        preemptible = each.value["preemptibl"]
    }
    network_interface {
        subnet_id = yandex_vpc_subnet.develop.id
        nat       = each.value["nat"]
        security_group_ids = [yandex_vpc_security_group.example.id]
    }
    metadata = {
        serial-port-enable = each.value["serial_port"]
        ssh-keys           = "${each.value["username"]}:${local.ssh_pub_key}"
    }
}