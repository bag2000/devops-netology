resource "local_file" "hosts_cfg" {
  content = templatefile("hosts.tftpl", { web =  yandex_compute_instance.web, db = yandex_compute_instance.db, storage = yandex_compute_instance.storage })
  filename = "hosts.cfg"
}

# db = yandex_compute_instance.db, storage = yandex_compute_instance.storage