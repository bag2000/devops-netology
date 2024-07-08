resource "yandex_compute_instance_group" "group1" {
  name                = "test-ig"
  folder_id           = var.folder_id
  service_account_id  = var.service_account_id
  deletion_protection = false

  health_check {
    interval = 10
    tcp_options {
      port = 80
    }
  }

  instance_template {
    platform_id = "standard-v1"
    resources {
      memory = var.vms_resources_memory
      cores  = var.vms_resources_cores
    }

    boot_disk {
      mode = var.vms_boot_disk_mode
      initialize_params {
        image_id = var.vms_boot_disk_img_id
      }
    }

    scheduling_policy {
        preemptible = var.preemptible
    }
    network_interface {
      network_id = "${yandex_vpc_network.netology.id}"
      subnet_ids = ["${yandex_vpc_subnet.public.id}"]
    }
    metadata = {
      user-data = "${file("cloud-init.yaml")}"
      ssh-keys = "${var.vms_username}:${var.vms_ssh_root_key}"
    }
    network_settings {
      type = var.network_settings
    }
  }

  scale_policy {
    fixed_scale {
      size = var.scale_policy
    }
  }

  allocation_policy {
    zones = [var.zone_a]
  }

  deploy_policy {
    max_unavailable = 2
    max_creating    = 2
    max_expansion   = 2
    max_deleting    = 2
  }

  load_balancer {
    target_group_name        = "target-group"
    target_group_description = "Целевая группа Network Load Balancer"
  }
}